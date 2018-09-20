#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install UnZip'
case $os_id in
  ol)
    sudo yum -y install unzip
    ;;
  amzn)
    sudo yum -y install unzip
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install unzip
    ;;
esac
