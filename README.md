# python-dind

A python image with docker, dockerd, docker-compose, and dind for use in ci. 

Uses/features:
- With testcontainers-python in a ci
- Running pytest e2e tests that use external services
- Having one image that can act as both the docker daemon and client
- No need to install python on `docker:dind` at the start of each job
- Glibc-based means it can use wheels from PYPI without building from source like on alpine python images


# How does this repo work?

The images are constructed automatically on a selected set of tags from the official python image, briefly tested, then uploaded.

- The Dockerfile merges instructions from the official [docker:dind Dockerfile](https://github.com/docker-library/docker/blob/master/Dockerfile-dind.template) and other debian based docker images
- The version fetching is inspired by the official docker image's [versions.sh](https://github.com/docker-library/docker/blob/master/versions.sh)
- Automatic image builds loosely based on [This blog post](https://www.flypenguin.de/2021/07/30/auto-rebuild-docker-images-if-base-image-changes-using-github-actions/) + the github actions documentation