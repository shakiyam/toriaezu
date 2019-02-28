#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

# Install Make
case $OS_ID in
  ol)
    sudo yum -y install make
    if [[ -e /usr/bin/ol_yum_configure.sh ]]; then
      sudo /usr/bin/ol_yum_configure.sh
      if [[ "${OS_VERSION%%.*}" -eq 7 ]]; then
        sudo yum install oracle-epel-release-el7.x86_64
      fi
    fi
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install make
    ;;
esac

make toriaezu
