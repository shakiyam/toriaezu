#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install ripgrep'
case $OS_ID in
  ol)
    install_package --epel ripgrep
    ;;
  ubuntu)
    install_package ripgrep
    ;;
esac

echo_info 'Verify ripgrep installation'
verify_installation rg
