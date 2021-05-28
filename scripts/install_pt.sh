#!/bin/bash
set -eu -o pipefail

echo 'Install The Platinum Searcher'
LATEST=$(
  curl -sSI https://github.com/monochromegane/the_platinum_searcher/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
case $(uname -m) in
  x86_64)
    ARCHITECTURE=amd64
    ;;
  aarch64)
    ARCHITECTURE=arm
    ;;
esac
readonly ARCHITECTURE
curl -L# "https://github.com/monochromegane/the_platinum_searcher/releases/download/${LATEST}/pt_linux_${ARCHITECTURE}.tar.gz" \
  | sudo tar xzf - -C /usr/local/bin/ --strip=1 pt_linux_${ARCHITECTURE}/pt
