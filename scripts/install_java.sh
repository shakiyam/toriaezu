#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install OpenJDK Development Kit'
case $OS_ID in
  ol)
    sudo yum -y install java-11-openjdk-devel
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install openjdk-11-jdk
    ;;
esac
