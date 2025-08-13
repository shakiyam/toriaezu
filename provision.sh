#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "$0")/scripts/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo_info 'Update system packages'
case $OS_ID in
  ol)
    sudo dnf -y upgrade
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
    ;;
esac

echo_info 'Install make and curl'
install_package make curl

if [[ $OS_ID == "ol" ]]; then
  echo_info 'Install EPEL repository'
  case $OS_VERSION in
    8*)
      install_package oracle-epel-release-el8
      ;;
    9*)
      install_package oracle-epel-release-el9
      ;;
    *)
      echo_warn "Unknown Oracle Linux version: $OS_VERSION"
      ;;
  esac
fi

if [[ $# -eq 0 ]]; then
  make toriaezu
else
  make "$@"
fi
