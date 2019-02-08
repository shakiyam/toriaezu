#!/bin/bash
set -eu -o pipefail

if [[ -e .env ]]; then
  # shellcheck disable=SC1091
  . .env
fi

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install NFS client'
case $OS_ID in
  ol)
    sudo yum -y install nfs-utils
    ;;
  ubuntu)
    sudo apt -y install nfs-common
    ;;
esac

echo 'Mount by nfs'
sudo mkdir -p "${NFS_MOUNT_POINT}"
sudo chown "$(id -u)":"$(id -g)" "${NFS_MOUNT_POINT}"
sudo mount "$NFS_REMOTETARGET" "${NFS_MOUNT_POINT}"
