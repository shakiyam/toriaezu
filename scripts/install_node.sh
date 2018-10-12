#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install Node.js'
case $os_id in
  ol)
    curl -sL https://rpm.nodesource.com/setup_8.x | sudo bash -
    sudo yum -y install nodejs gcc-c++ make
    ;;
  ubuntu)
    curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
    sudo apt -y install nodejs build-essential
    ;;
esac
