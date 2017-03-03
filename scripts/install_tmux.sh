#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

# Install tmux
case $os_id in
  ol | amzn)
    yum -y install tmux
    ;;
  ubuntu)
    apt -y install tmux
    ;;
esac
