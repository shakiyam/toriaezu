#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

# Install Make
case $os_id in
  ol | amzn)
    yum -y install make
    ;;
  ubuntu)
    apt update
    apt -y install make
    ;;
esac

make toriaezu

# Copy dotfiles
cp "$(cd "$(dirname "$0")" && pwd)/.bashrc" "/home/$(logname)/.bashrc"
chown "$(logname)":"$(id -g "$(logname)")" "/home/$(logname)/.bashrc"
cp "$(cd "$(dirname "$0")" && pwd)/.tmux.conf" "/home/$(logname)/.tmux.conf"
chown "$(logname)":"$(id -g "$(logname)")" "/home/$(logname)/.tmux.conf"
cp "$(cd "$(dirname "$0")" && pwd)/.tmux.ge_2.1.conf" "/home/$(logname)/.tmux.ge_2.1.conf"
chown "$(logname)":"$(id -g "$(logname)")" "/home/$(logname)/.tmux.ge_2.1.conf"
cp "$(cd "$(dirname "$0")" && pwd)/.tmux.lt_2.1.conf" "/home/$(logname)/.tmux.lt_2.1.conf"
chown "$(logname)":"$(id -g "$(logname)")" "/home/$(logname)/.tmux.lt_2.1.conf"
