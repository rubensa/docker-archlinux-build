# Docker image based on rubensa/archlinux for building archlinux packages

This is a Docker image based on [rubensa/archlinux](https://hub.docker.com/_/archlinux/) that allows you to build Arch Linux packages.

The internal user (user) has sudo and the image includes [fixuid](https://github.com/boxboat/fixuid) so you can set internal user (user) UID and internal group (group) GID to your current UID and GID by providing that info means of "--user" docker running option.

## Building

You can build the image like this:

```
#!/usr/bin/env bash

DOCKER_REPOSITORY_NAME="rubensa"
DOCKER_IMAGE_NAME="archlinux-build"
DOCKER_IMAGE_TAG="latest"

docker build --no-cache \
  -t "${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
  .
```

## Running

You can run the container like this:

```
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
```

This way, the internal user UID and group GID are changed to the current host user:group launching the container and the existing files under his internal HOME directory that where owned by user and group are also updated to belong to the new UID:GID.

Also, a /work directory in the container is bind mounted to the current host working directory so you can share files between host and container.

## Usage

### Build AUR packages

The following command will download AUR package and build it:

```
$ docker run --rm -v $(pwd):/work rubensa/archlinux-build /bin/bash -c 'build-aur <package-name>'
```

### Build repo packages

The following command will download official repo package and build it:

```
$ docker run --rm -v $(pwd):/work rubensa/archlinux-build /bin/bash -c 'build-repo <package-name>'
```

### Build PKGBUILD

The following command will build local PKGBUILD file (must reside in /work/<package-name> directory):

```
$ docker run --rm -v $(pwd):/work rubensa/archlinux-build /bin/bash -c 'build-pkgbuild <package-name>'
```

`.SRCINFO` file will be updated/created in /work/<package-name> directory.

### Compiled package location

The binary will be placed in the `/work/<package-name>-pkg` folder, which in the example above is mounted to the current directory on the host.