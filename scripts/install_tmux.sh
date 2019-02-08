#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install tmux'
case $OS_ID in
  ol)
    sudo yum -y install tmux
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install tmux
    ;;
esac
