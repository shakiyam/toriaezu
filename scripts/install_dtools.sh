#!/bin/bash
set -eu -o pipefail

BIN_DIR=$(cd "$(dirname "$0")/../bin" && pwd)
readonly BIN_DIR

echo 'Install dtools'
mkdir -p "$HOME/bin"
cp -v "$BIN_DIR/dcls" "$HOME/bin/"
cp -v "$BIN_DIR/dclogs" "$HOME/bin/"
