#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install csvq'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
rm -f "$HOME/.local/bin/csvq" # Remove binary installed by go install in older versions
mise unuse --global go:github.com/mithrandie/csvq
mise use --global github:mithrandie/csvq@latest
eval "$(mise activate bash)"

echo_info 'Verify csvq installation'
verify_installation csvq
