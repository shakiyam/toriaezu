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

echo 'Install fzf'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      8)
        sudo dnf -y --enablerepo=ol8_developer_EPEL install fzf
        ;;
      9)
        sudo dnf -y --enablerepo=ol9_developer_EPEL install fzf
        ;;
    esac
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install fzf
    ;;
esac
