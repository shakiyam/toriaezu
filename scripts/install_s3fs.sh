#!/bin/bash
set -eu -o pipefail

if [[ -e .env ]]; then
  # shellcheck disable=SC1091
  . .env
fi

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(
  . /etc/os-release
  echo "$VERSION"
)
readonly OS_VERSION

echo 'Install s3fs'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        sudo yum -y --enablerepo=ol7_developer_EPEL install s3fs-fuse
        ;;
      8)
        sudo dnf -y --enablerepo=ol8_developer_EPEL install s3fs-fuse
        ;;
      9)
        echo 's3fs is not yet supported on Oracle Linux 9.'
        exit 0
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install s3fs
    ;;
esac

if [[ -n "${AWS_ACCESS_KEY_ID:-}" && -n "${AWS_SECRET_ACCESS_KEY:-}" && -n "${BUCKET:-}" && -n "${MOUNT_POINT:-}" ]]; then
  echo 'Mount s3fs'
  echo "$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY" | sudo tee /etc/passwd-s3fs >/dev/null
  sudo chmod 640 /etc/passwd-s3fs
  sudo mkdir -p "${MOUNT_POINT}"
  sudo s3fs "$BUCKET" "${MOUNT_POINT}" -o rw,allow_other,uid="$(id -u)",gid="$(id -g)",default_acl=public-read
fi
