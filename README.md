# Docker development environment image

## Info
* Stefano Gurrieri <stefano.gurrieri@roj.com>

## Description
This is a Docker image to use for development tests; specifically it's a docker image used to develop the POC for Agrirouter interface.
Anyway, you can build or download this image and use it like "base" image for your developments.
For the list of the main packages installed take a look at Dockerfile.

## Usage of repository

#### Build the image on your Host PC
- Clone the repository

```sh
$ git clone git@github.com:ROJ-ITALY/docker-dev-env.git
```

- Build the docker image `dev-env`

```sh
$ cd docker-dev-env/
$ docker build --build-arg USER_PASSWORD=*** -t dev-env:latest .
```

#### Download the image from GHCR
Click [here](https://github.com/ROJ-ITALY/docker-dev-env/pkgs/container/docker-dev-env%2Fdev-env) and follow the instructions to download docker image for your developments.

#### Run dev-env container (this is just an example)
```sh
$ docker run --rm -it -v /path/to/projects:/home/user/projects dev-env:latest
```

