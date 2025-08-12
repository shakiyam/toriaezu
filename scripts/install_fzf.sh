#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install fzf'
case $OS_ID in
  ol)
    install_package --epel fzf
    ;;
  ubuntu)
    install_package fzf
    ;;
esac

echo_info 'Verify fzf installation'
verify_installation fzf
