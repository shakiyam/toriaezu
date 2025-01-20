#!/bin/bash
set -eu -o pipefail

command_exits() {
  command -v "$1" &>/dev/null
}

command_exits /usr/local/bin/cho || command_exits "$HOME"/go/bin/cho || command_exits fzy || command_exits peco || {
  echo "ERROR: To install enhancd, you will need cho or fzy or peco."
  exit 1
}

echo 'Install enhancd'
LATEST=$(
  curl -sSI https://github.com/babarot/enhancd/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
mkdir -p "$HOME/.enhancd"
curl -L# https://github.com/babarot/enhancd/archive/refs/tags/${LATEST}.tar.gz \
  | tar xzf - -C "$HOME/.enhancd" enhancd-${LATEST#v} --strip=1
