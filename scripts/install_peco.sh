#!/bin/bash
set -eu -o pipefail

echo 'Install peco'
LATEST=$(
  curl -sSI https://github.com/peco/peco/releases/latest \
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
curl -L# "https://github.com/peco/peco/releases/download/${LATEST}/peco_linux_${ARCHITECTURE}.tar.gz" \
  | sudo tar xzf - -C /usr/local/bin/ --strip=1 peco_linux_${ARCHITECTURE}/peco
