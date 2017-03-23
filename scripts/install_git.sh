#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install Git'
case $os_id in
  ol | amzn)
    sudo yum -y install git
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install git
    ;;
esac
