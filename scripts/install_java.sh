#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install OpenJDK Development Kit'
case $os_id in
  ol)
    sudo yum -y install java-1.8.0-openjdk-devel
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install openjdk-8-jdk
    ;;
esac
