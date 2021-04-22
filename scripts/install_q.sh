#!/bin/bash
set -eu -o pipefail

echo 'Install Q'
LATEST=$(
  curl -sSI https://github.com/harelba/q/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
curl -L# "https://github.com/harelba/q/releases/download/${LATEST}/q-x86_64-Linux" \
  | sudo tee /usr/local/bin/q >/dev/null
sudo chmod +x /usr/local/bin/q
