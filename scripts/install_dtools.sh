#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

BIN_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../bin" && pwd)
readonly BIN_DIR

echo_info 'Install dtools'
mkdir -p "$HOME/.local/bin"
cp -v "$BIN_DIR/dcls" "$HOME/.local/bin/"
cp -v "$BIN_DIR/dclogs" "$HOME/.local/bin/"
