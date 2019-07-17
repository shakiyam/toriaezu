#!/bin/bash
set -eu -o pipefail

readonly BIN_DIR=$(cd "$(dirname "$0")/../bin" && pwd)

echo 'Install dtools'
mkdir -p "$HOME/bin"
cp -v "$BIN_DIR/dcls" "$HOME/bin/"
cp -v "$BIN_DIR/dclogs" "$HOME/bin/"
