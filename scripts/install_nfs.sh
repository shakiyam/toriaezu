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

echo 'Install NFS client'
case $OS_ID in
  ol)
    sudo yum -y install nfs-utils
    ;;
  ubuntu)
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install nfs-common
    ;;
esac

if [[ -n "${NFS_MOUNT_POINT:-}" && -n "${NFS_REMOTETARGET:-}" ]]; then
  echo 'Mount by nfs'
  sudo mkdir -p "${NFS_MOUNT_POINT}"
  sudo chown "$(id -u)":"$(id -g)" "${NFS_MOUNT_POINT}"
  sudo mount "$NFS_REMOTETARGET" "${NFS_MOUNT_POINT}"
fi
