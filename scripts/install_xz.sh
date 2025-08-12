#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "$0")/common.sh"

echo_info 'Install xz'
OS_ID=$(get_os_id)
case $OS_ID in
  ol)
    install_package xz
    ;;
  ubuntu)
    install_package xz-utils
    ;;
  *)
    die "Error: Unsupported OS $OS_ID"
    ;;
esac
