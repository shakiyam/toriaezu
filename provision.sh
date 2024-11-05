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
    case ${OS_VERSION%%.*} in
      7)
        sudo yum -y upgrade
        sudo yum -y install make oracle-epel-release-el7
        ;;
      8)
        sudo dnf -y upgrade
        sudo dnf -y install make oracle-epel-release-el8
        ;;
      9)
        sudo dnf -y upgrade
        sudo dnf -y install make oracle-epel-release-el9
        ;;
    esac
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install make
    ;;
esac

make toriaezu
