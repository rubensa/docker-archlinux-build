# syntax=docker/dockerfile:1.4
FROM rubensa/archlinux:latest

LABEL \
  org.opencontainers.image.title="Container for building archlinux packages" \
  org.opencontainers.image.description="Arch Linux image that allows you to build Arch Linux packages" \
  org.opencontainers.image.authors="Ruben Suarez Alvarez <rubensa@gmail.com>" \
  org.opencontainers.image.vendor="rubensa" \
  org.opencontainers.image.url="https://hub.docker.com/r/rubensa/archlinux-build" \
  org.opencontainers.image.source="https://github.com/rubensa/docker-archlinux-build" \
  org.opencontainers.image.licenses="AGPL-3.0"

RUN <<EOT
  sudo pacman -Syu --noconfirm --needed base base-devel devtools
EOT

RUN <<EOT
  mkdir -p /home/${USER_NAME}/{.config/pacman,.gnupg,.ssh,out}
  echo 'MAKEFLAGS="-j$(nproc)"' >> /home/${USER_NAME}/.config/pacman/makepkg.conf
  echo 'PKGDEST="/home/${USER_NAME}/out"' >> /home/${USER_NAME}/.config/pacman/makepkg.conf
  echo 'keyserver-options auto-key-retrieve' > /home/${USER_NAME}/.gnupg/gpg.conf
EOT

COPY build-aur build-pkgbuild build-repo /usr/local/bin/

RUN <<EOT
  sudo chmod +x /usr/local/bin/build-aur
  sudo chmod +x /usr/local/bin/build-pkgbuild
  sudo chmod +x /usr/local/bin/build-repo
EOT