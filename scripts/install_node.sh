#!/bin/bash
set -eu -o pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo 'Install Node.js'
# Check the latest version from https://nodejs.org/en/ and https://github.com/nodesource/distributions
case $OS_ID in
  ol)
    curl -sL https://rpm.nodesource.com/setup_lts.x | sudo -E bash -
    install_package nodejs gcc-c++ make
    ;;
  ubuntu)
    curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    install_package nodejs build-essential
    ;;
esac
