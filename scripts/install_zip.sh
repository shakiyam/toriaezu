#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install Zip'
case $OS_ID in
  ol)
    sudo yum -y install zip
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install zip
    ;;
esac
