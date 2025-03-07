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

echo 'Install Python3'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      8)
        sudo dnf -y install python39 python39-pip
        ;;
      9)
        sudo dnf -y install python39 python-pip
        ;;
    esac
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python3-venv
    ;;
esac
python3 -m venv "$HOME/python3"
