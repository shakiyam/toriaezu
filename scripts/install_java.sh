#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID

echo 'Install OpenJDK Development Kit'
case $OS_ID in
  ol)
    sudo dnf -y install java-17-openjdk-devel
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install openjdk-17-jdk
    ;;
esac
