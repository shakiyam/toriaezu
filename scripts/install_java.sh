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

echo 'Install OpenJDK Development Kit'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        sudo yum -y install java-11-openjdk-devel
        ;;
      8)
        sudo dnf -y install java-17-openjdk-devel
        ;;
      9)
        sudo dnf -y install java-17-openjdk-devel
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo DEBIAN_FRONTEND=noninteractive apt -y install openjdk-17-jdk
    ;;
esac
