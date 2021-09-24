#!/bin/bash
set -eu -o pipefail

command_exits() {
  command -v "$1" >/dev/null 2>&1
}

command_exits /usr/local/bin/cho || command_exits "$HOME"/bin/cho || command_exits fzy || command_exits peco || {
  echo "ERROR: To install enhancd, you will need cho or fzy or peco."
  exit 1
}

echo 'Install enhancd'
mkdir -p "$HOME/.enhancd"
curl -L# https://github.com/b4b4r07/enhancd/archive/master.tar.gz \
  | tar xzf - -C "$HOME/.enhancd" enhancd-master --strip=1
