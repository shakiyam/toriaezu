#!/bin/bash
set -eu -o pipefail

echo 'Install Bash Line Editor'
mkdir -p "$HOME/.blesh"
readonly LATEST=$(
  curl -sSI https://github.com/akinomyoga/ble.sh/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
curl -L# "https://github.com/akinomyoga/ble.sh/releases/download/${LATEST}/ble-${LATEST#v}.tar.xz" \
  | tar xJf - -C "$HOME/.blesh" --strip=1
