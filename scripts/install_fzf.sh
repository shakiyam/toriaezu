#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo_info 'Install fzf'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      8)
        sudo dnf -y --enablerepo=ol8_developer_EPEL install fzf
        ;;
      9)
        sudo dnf -y --enablerepo=ol9_developer_EPEL install fzf
        ;;
    esac
    ;;
  ubuntu)
    install_package fzf
    ;;
esac
