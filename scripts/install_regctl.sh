#!/bin/bash
set -eu -o pipefail

echo 'Install regctl'
LATEST=$(
  curl -sSI https://github.com/regclient/regclient/releases/latest \
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
curl -L# "https://github.com/regclient/regclient/releases/download/${LATEST}/regctl-linux-${ARCHITECTURE}" \
  | sudo tee /usr/local/bin/regctl >/dev/null
sudo chmod 755 /usr/local/bin/regctl
