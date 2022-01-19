#!/bin/bash
set -eu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR

echo 'Install cho'
case $(uname -m) in
  x86_64)
    LATEST=$(
      curl -sSI https://github.com/mattn/cho/releases/latest \
        | tr -d '\r' \
        | awk -F'/' '/^[Ll]ocation:/{print $NF}'
    )
    readonly LATEST
    curl -L# "https://github.com/mattn/cho/releases/download/${LATEST}/cho_${LATEST}_linux_amd64.tar.gz" \
      | sudo tar xzf - -C /usr/local/bin/ --strip=1 "cho_${LATEST}_linux_amd64/cho"
    ;;
  aarch64)
    "$SCRIPT_DIR/install_go.sh"
    /usr/local/go/bin/go install github.com/mattn/cho@latest
    ;;
esac
