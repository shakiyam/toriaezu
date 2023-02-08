#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID

echo 'Install tmux'
case $OS_ID in
  ol)
    sudo yum -y install tmux
    ;;
  ubuntu)
    sudo apt update
    sudo DEBIAN_FRONTEND=noninteractive apt -y install tmux
    ;;
esac
