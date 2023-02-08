#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID

echo 'Install Node.js'
# Check the latest version from https://nodejs.org/en/ and https://github.com/nodesource/distributions
case $OS_ID in
  ol)
    curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash -
    sudo yum -y install nodejs gcc-c++ make
    ;;
  ubuntu)
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo DEBIAN_FRONTEND=noninteractive apt -y install nodejs build-essential
    ;;
esac
