#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install tmux'
case $os_id in
  ol)
    sudo yum -y install tmux
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install tmux
    ;;
esac
