#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

BIN_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../bin" && pwd)
readonly BIN_DIR

echo_info 'Install dtools'
install -v -D -m 755 "$BIN_DIR/dcls" "$HOME/.local/bin/dcls"
install -v -m 755 "$BIN_DIR/dclogs" "$HOME/.local/bin/dclogs"

echo_info 'Verify dtools installation'
verify_command dcls
verify_command dclogs
