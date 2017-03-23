#!/bin/bash
set -eu -o pipefail
shopt -s dotglob

dotfiles_dir=$(cd "$(dirname "$0")/../dotfiles" && pwd)

echo 'Copy dotfiles'
for file in $(cd "$dotfiles_dir" && echo .[!.]*)
do
  cp -v "$dotfiles_dir/$file" "/home/$(logname)/$file"
  chown "$(logname)":"$(id -g "$(logname)")" "/home/$(logname)/$file"
done
