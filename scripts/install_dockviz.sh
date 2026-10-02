#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install dockviz'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
rm -f "$HOME/.local/bin/dockviz" # Remove binary installed by go install in older versions
mise use --global go:github.com/justone/dockviz@latest
eval "$(mise activate bash)"

echo_info 'Verify dockviz installation'
verify_installation dockviz
