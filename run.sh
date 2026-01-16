#!/usr/bin/env bash

DOCKER_REPOSITORY_NAME="rubensa"
DOCKER_IMAGE_NAME="archlinux-build"
DOCKER_IMAGE_TAG="latest"

# Get current user UID
USER_ID=$(id -u)
# Get current user main GID
GROUP_ID=$(id -g)

prepare_docker_timezone() {
  # https://www.waysquare.com/how-to-change-docker-timezone/
  ENV_VARS+=" --env=TZ=$(realpath --relative-to /usr/share/zoneinfo /etc/localtime)"
}

prepare_docker_user_and_group() {
  RUNNER+=" --user=${USER_ID}:${GROUP_ID}"
}

prepare_docker_userdata_volumes() {
  # Shared working directory
  MOUNTS+=" --mount type=bind,source=${PWD},target=/work"
}
prepare_docker_timezone
prepare_docker_user_and_group
prepare_docker_userdata_volumes

docker run --rm --init -it \
  --name "${DOCKER_IMAGE_NAME}" \
  ${ENV_VARS} \
  ${RUNNER} \
  ${MOUNTS} \
  "${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" "$@"
