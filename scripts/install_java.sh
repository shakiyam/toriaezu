#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install OpenJDK Development Kit'
case $os_id in
  ol)
    sudo yum -y install java-1.8.0-openjdk-devel
    ;;
  amzn)
    sudo yum -y install java-1.8.0-openjdk-devel
    sudo alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
    sudo alternatives --set javac /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/javac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install openjdk-8-jdk
    ;;
esac
