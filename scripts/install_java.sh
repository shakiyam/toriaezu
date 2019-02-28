#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install OpenJDK Development Kit'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      6)
        sudo yum -y install java-1.8.0-openjdk-devel
        ;;
      7)
        sudo yum -y install java-11-openjdk-devel
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install openjdk-11-jdk
    ;;
esac
