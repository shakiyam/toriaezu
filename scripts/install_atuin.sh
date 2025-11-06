#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install atuin'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
mise use --global atuin@latest
eval "$(mise activate bash)"

echo_info 'Verify atuin installation'
verify_installation atuin
