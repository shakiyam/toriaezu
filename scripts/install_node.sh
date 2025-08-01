#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install Node.js'
case $OS_ID in
  ol)
    curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
    install_package nodejs gcc-c++ make
    ;;
  ubuntu)
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
    install_package nodejs build-essential
    ;;
esac
