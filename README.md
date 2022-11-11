# Docker development environment image

## Info
* Stefano Gurrieri <stefano.gurrieri@roj.com>

## Description
This is a Docker image to use for development tests.
For the list of the main packages installed take a look at Dockerfile.

## Usage of repository

#### Build the image
- Clone the repository

```sh
$ git clone git@github.com:ROJ-ITALY/docker-dev-env.git
```

- Build the docker image `dev-env`

```sh
$ cd docker-dev-env/
$ docker build --build-arg USER_PASSWORD=*** -t dev-env:latest .
```

#### Run dev-env container (this is an example)
```sh
$ docker run --rm -it -v /path/to/projects:/home/user/projects dev-env:latest
```

