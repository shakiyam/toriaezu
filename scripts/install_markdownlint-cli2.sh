#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install markdownlint-cli2'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
mise use --global markdownlint-cli2@latest
eval "$(mise activate bash)"

echo_info 'Verify markdownlint-cli2 installation'
verify_installation markdownlint-cli2
