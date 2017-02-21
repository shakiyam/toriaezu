#!/bin/bash

make toriaezu

# Copy dotfiles
cp "$(cd "$(dirname "$0")" && pwd)/.bashrc" "/home/$(logname)/.bashrc"
chown "$(logname)":"$(id -g "$(logname)")" "/home/$(logname)/.bashrc"
cp "$(cd "$(dirname "$0")" && pwd)/.tmux.conf" "/home/$(logname)/.tmux.conf"
chown "$(logname)":"$(id -g "$(logname)")" "/home/$(logname)/.tmux.conf"
