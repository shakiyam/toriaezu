#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/scripts/common.sh"

echo_info 'Update system packages'
case $(get_os_id) in
  ol)
    sudo dnf -y upgrade
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
    ;;
esac

echo_info 'Install Make'
install_package make

if [[ $(get_os_id) == "ol" ]]; then
  echo_info 'Install EPEL repository'
  case $(get_os_version) in
    8*)
      install_package oracle-epel-release-el8
      ;;
    9*)
      install_package oracle-epel-release-el9
      ;;
    *)
      echo_warn "Unknown Oracle Linux version: $(get_os_version)"
      ;;
  esac
fi

make toriaezu
