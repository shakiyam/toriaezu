#!/bin/bash
set -eu -o pipefail

echo 'Install cho'
case $(uname -m) in
  x86_64)
    ARCHITECTURE=amd64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
esac
readonly ARCHITECTURE
LATEST=$(
  curl -sSI https://github.com/mattn/cho/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
curl -L# "https://github.com/mattn/cho/releases/download/${LATEST}/cho_${LATEST}_linux_${ARCHITECTURE}.tar.gz" \
  | sudo tar xzf - -C /usr/local/bin/ --strip=1 "cho_${LATEST}_linux_${ARCHITECTURE}/cho"
