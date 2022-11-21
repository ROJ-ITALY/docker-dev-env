FROM ubuntu:22.04

# Set ROJ proxy
RUN echo "Acquire::http::Proxy \"http://192.168.1.107:8080/\";" > /etc/apt/apt.conf

# Install deb packages to build protobuf from source (see README.md under src/)
# Install Python 3.10.6 (>=3.7 to support python c++ implementation proto runtime library version 4.21.9)
# Install other useful packages
RUN apt-get update && apt-get install -y autoconf automake libtool curl make g++ unzip \
										 python-is-python3 python3-pip \
										 pkg-config iputils-ping iproute2 net-tools sudo git libffi-dev

# Add username: user
#     password: ${USER_PASSWORD}
ARG USER_PASSWORD
RUN useradd -ms /bin/bash -G sudo -p "$(openssl passwd -1 ${USER_PASSWORD})" user

USER user

# AG SDK PYTHON seems depending from protobuf 3.18.3 so it's not necessary build and install protobuf last version.
#******************
#COPY protobuf-all-21.9.tar.gz /home/user
# Build and install C++ proto runtime library (version 3.21.9) and protoc (version 3.21.9)
#RUN cd /home/user && tar xvzf protobuf-all-21.9.tar.gz && cd protobuf-21.9/ && \
#	./configure && \
#	make -j8 && \
#	make check
#USER root
#RUN cd /home/user/protobuf-21.9/ && make install && ldconfig

# Build and install Python C++ implementation proto runtime library (version 4.21.9)
#USER user
RUN pip3 install tzdata
#RUN cd /home/user/protobuf-21.9/python && python setup.py build --cpp_implementation && python setup.py test --cpp_implementation
#USER root
#RUN cd /home/user/protobuf-21.9/python && python setup.py install --cpp_implementation
#******************

# Add protoc binary (version 3.18.3)
COPY protoc-3.18.3-linux-x86_64.zip /home/user
RUN cd /home/user && unzip protoc-3.18.3-linux-x86_64.zip -d protoc_3.18.3
USER root
RUN cp /home/user/protoc_3.18.3/bin/protoc /usr/local/bin/protoc && chmod 755 /usr/local/bin/protoc

USER user

# Install AG SDK python
RUN cd /home/user && git clone -b master https://github.com/DKE-Data/agrirouter-sdk-python.git
USER root
RUN cd /home/user/agrirouter-sdk-python && python setup.py install

USER user

RUN mkdir /home/user/projects
WORKDIR /home/user
