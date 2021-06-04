#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(
  . /etc/os-release
  echo "$VERSION"
)
readonly OS_VERSION

# Install Make
case $OS_ID in
  ol)
    sudo yum -y install make
    case ${OS_VERSION%%.*} in
      7)
        sudo yum -y install oracle-epel-release-el7
        ;;
      8)
        sudo dnf -y install oracle-epel-release-el8
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install make
    ;;
esac

make toriaezu
