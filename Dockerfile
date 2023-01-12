FROM ubuntu:20.04

# Add description
LABEL org.opencontainers.image.description "Docker image to develop the POC for Agrirouter interface."

# Set ROJ proxy
RUN echo "Acquire::http::Proxy \"http://192.168.1.107:8080/\";" > /etc/apt/apt.conf

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf automake libtool curl make g++ unzip \
										 python-is-python3 python3-pip \
										 pkg-config iputils-ping iproute2 net-tools sudo git libffi-dev

# Add username: user
#     password: ${USER_PASSWORD}
ARG USER_PASSWORD
RUN useradd -ms /bin/bash -G sudo -p "$(openssl passwd -1 ${USER_PASSWORD})" user

USER user
# Add protoc binary (version 3.18.3)
RUN mkdir /home/user/projects
COPY protoc-3.18.3-linux-x86_64.zip /home/user/projects
RUN cd /home/user/projects && unzip protoc-3.18.3-linux-x86_64.zip -d protoc_3.18.3
USER root
RUN cp /home/user/projects/protoc_3.18.3/bin/protoc /usr/local/bin/protoc && chmod 755 /usr/local/bin/protoc

USER user
# Install AG SDK python
RUN cd /home/user/projects && git clone -b poc_cu_roj https://github.com/ROJ-ITALY/agrirouter-sdk-python.git

USER root
RUN cd /home/user/projects/agrirouter-sdk-python && python setup.py install
RUN cd /usr/local/lib/python3.8/dist-packages && mv agrirouter-1.0.0-py3.8.egg agrirouter-1.0.0-py3.8.zip && unzip -d agrirouter-1.0.0-py3.8.egg agrirouter-1.0.0-py3.8.zip && rm agrirouter-1.0.0-py3.8.zip

# Install canopen (2.1.0) and python-can (4.1.0)
RUN pip3 install canopen

# Install tzdata python module
RUN pip3 install tzdata

# Kvaser's canlib
COPY libcanlib.so.1.10.1 /usr/lib
RUN cd /usr/lib && ln -s libcanlib.so.1.10.1 libcanlib.so.1
RUN cd /usr/lib && ln -s libcanlib.so.1.10.1 libcanlib.so

USER user

WORKDIR /home/user
