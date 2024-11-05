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

echo 'Install Node.js'
# Check the latest version from https://nodejs.org/en/ and https://github.com/nodesource/distributions
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash -
        sudo yum -y install nodejs gcc-c++ make
        ;;
      8)
        curl -sL https://rpm.nodesource.com/setup_lts.x | sudo -E bash -
        sudo dnf -y install nodejs gcc-c++ make
        ;;
      9)
        curl -sL https://rpm.nodesource.com/setup_lts.x | sudo -E bash -
        sudo dnf -y install nodejs gcc-c++ make
        ;;
    esac
    ;;
  ubuntu)
    curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs build-essential
    ;;
esac
