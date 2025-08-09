#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if [[ -e .env ]]; then
  # shellcheck disable=SC1091
  . .env
fi

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install s3fs'
case $OS_ID in
  ol)
    install_package --epel s3fs-fuse
    ;;
  ubuntu)
    install_package s3fs
    ;;
esac

if [[ -n "${AWS_ACCESS_KEY_ID:-}" && -n "${AWS_SECRET_ACCESS_KEY:-}" && -n "${BUCKET:-}" && -n "${MOUNT_POINT:-}" ]]; then
  echo_info 'Mount s3fs'
  echo "$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY" | sudo install -m 600 /dev/stdin /etc/passwd-s3fs
  sudo mkdir -p "${MOUNT_POINT}"
  sudo s3fs "$BUCKET" "${MOUNT_POINT}" -o rw,allow_other,uid="$(id -u)",gid="$(id -g)",default_acl=public-read
fi
