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
    ;;
esac

# Copy dotfiles
cp "$(cd "$(dirname "$0")/.." && pwd)/.tmux.conf" "/home/$(logname)/.tmux.conf"
chown "$(logname)":"$(id -g "$(logname)")" "/home/$(logname)/.tmux.conf"
