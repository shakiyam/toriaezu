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
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo_info 'Install s3fs'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      8)
        sudo dnf -y --enablerepo=ol8_developer_EPEL install s3fs-fuse
        ;;
      9)
        sudo dnf -y --enablerepo=ol9_developer_EPEL install s3fs-fuse
        ;;
    esac
    ;;
  ubuntu)
    install_package s3fs
    ;;
esac

if [[ -n "${AWS_ACCESS_KEY_ID:-}" && -n "${AWS_SECRET_ACCESS_KEY:-}" && -n "${BUCKET:-}" && -n "${MOUNT_POINT:-}" ]]; then
  echo_info 'Mount s3fs'
  echo "$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY" | sudo tee /etc/passwd-s3fs >/dev/null
  sudo chmod 640 /etc/passwd-s3fs
  sudo mkdir -p "${MOUNT_POINT}"
  sudo s3fs "$BUCKET" "${MOUNT_POINT}" -o rw,allow_other,uid="$(id -u)",gid="$(id -g)",default_acl=public-read
fi
