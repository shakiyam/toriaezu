#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID

echo 'Install Zip'
case $OS_ID in
  ol)
    sudo yum -y install zip
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install zip
    ;;
esac
