#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install Node.js'
if ! command -v mise &>/dev/null; then
  die "mise is required but not installed. Run 'make install_mise' first."
fi

eval "$(mise activate bash)"
mise use --global node@lts
eval "$(mise activate bash)"

echo_info 'Verify Node.js installation'
verify_installation node
verify_installation npm
