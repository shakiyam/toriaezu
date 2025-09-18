#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install kubectl'
if ! command -v mise &>/dev/null; then
  die "mise is required but not installed. Run 'make install_mise' first."
fi

eval "$(mise activate bash)"
mise use --global kubectl@latest
eval "$(mise activate bash)"

echo_info 'Verify kubectl installation'
verify_installation kubectl
