#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install Python3'
case $OS_ID in
  ol)
    sudo yum -y --enablerepo=ol7_developer_EPEL install python36
    python3 -m venv "$HOME/python3"
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install python3-venv
    python3 -m venv "$HOME/python3"
    ;;
esac
