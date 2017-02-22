#!/bin/bash

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
