#!/usr/bin/env bash

DOCKER_REPOSITORY_NAME="rubensa"
DOCKER_IMAGE_NAME="archlinux-build"
DOCKER_IMAGE_TAG="latest"

docker build --no-cache \
  -t "${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
  .
