#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/colored_echo.sh"

BIN_DIR=$(cd "$(dirname "$0")/../bin" && pwd)
readonly BIN_DIR

echo_info 'Install dtools'
mkdir -p "$HOME/bin"
cp -v "$BIN_DIR/dcls" "$HOME/bin/"
cp -v "$BIN_DIR/dclogs" "$HOME/bin/"
