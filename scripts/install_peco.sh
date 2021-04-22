#!/bin/bash
set -eu -o pipefail

echo 'Install peco'
LATEST=$(
  curl -sSI https://github.com/peco/peco/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
curl -L# "https://github.com/peco/peco/releases/download/${LATEST}/peco_linux_amd64.tar.gz" \
  | sudo tar xzf - -C /usr/local/bin/ --strip=1 peco_linux_amd64/peco
