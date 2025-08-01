#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if [[ -e .env ]]; then
  # shellcheck disable=SC1091
  . .env
fi

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install NFS client'
case $OS_ID in
  ol)
    install_package nfs-utils
    ;;
  ubuntu)
    install_package nfs-common
    ;;
esac

if [[ -n "${NFS_MOUNT_POINT:-}" && -n "${NFS_REMOTETARGET:-}" ]]; then
  echo_info 'Mount by nfs'
  sudo mkdir -p "${NFS_MOUNT_POINT}"
  sudo chown "$(id -u)":"$(id -g)" "${NFS_MOUNT_POINT}"
  sudo mount "$NFS_REMOTETARGET" "${NFS_MOUNT_POINT}"
fi
