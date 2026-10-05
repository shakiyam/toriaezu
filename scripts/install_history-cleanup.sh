#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

BIN_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../bin" && pwd)
readonly BIN_DIR

echo_info 'Install history-cleanup'
if ! command -v fish &>/dev/null; then
  die "Error: Command not found: fish. Run 'make install_fish'."
fi
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi
eval "$(mise activate bash)"
if ! command -v atuin &>/dev/null; then
  die "Error: Command not found: atuin. Run 'make install_atuin'."
fi
install -v -D -m 755 "$BIN_DIR/history-cleanup.fish" "$HOME/.local/bin/history-cleanup"

echo_info 'Verify history-cleanup installation'
verify_installation history-cleanup
