#!/bin/bash
set -eu -o pipefail

echo 'Install shfmt'
LATEST=$(
  curl -sSI https://github.com/mvdan/sh/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
case $(uname -m) in
  x86_64)
    ARCHITECTURE=amd64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
esac
readonly ARCHITECTURE
curl -L# "https://github.com/mvdan/sh/releases/download/${LATEST}/shfmt_${LATEST}_linux_${ARCHITECTURE}" \
  | sudo tee /usr/local/bin/shfmt >/dev/null
sudo chmod 755 /usr/local/bin/shfmt
