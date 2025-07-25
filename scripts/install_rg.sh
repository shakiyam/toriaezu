#!/bin/bash
set -eu -o pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo 'Install ripgrep'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      8)
        sudo dnf -y --enablerepo=ol8_developer_EPEL install ripgrep
        ;;
      9)
        sudo dnf -y --enablerepo=ol9_developer_EPEL install ripgrep
        ;;
    esac
    ;;
  ubuntu)
    install_package ripgrep
    ;;
esac
