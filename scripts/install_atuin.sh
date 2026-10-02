#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install atuin'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
if [[ "$OS_ID" == "ol" ]]; then
  echo_info 'Using musl static binary for GLIBC compatibility on Oracle Linux'
  mise unuse --global atuin
  mise use --global "github:atuinsh/atuin[asset_pattern=atuin-$(uname -m)-unknown-linux-musl.tar.gz]@latest"
else
  mise use --global atuin@latest
fi
eval "$(mise activate bash)"

echo_info 'Verify atuin installation'
verify_installation atuin
