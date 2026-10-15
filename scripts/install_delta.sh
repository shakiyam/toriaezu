#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo_info 'Install delta'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
if [[ "$OS_ID" == "ol" && "${OS_VERSION%%.*}" == "8" && "$(uname -m)" == "x86_64" ]]; then
  echo_info 'Using musl static binary for GLIBC compatibility on Oracle Linux 8'
  mise unuse --global delta
  mise use --global "github:dandavison/delta[asset_pattern=delta-*-x86_64-unknown-linux-musl.tar.gz]@latest"
else
  mise use --global delta@latest
fi
eval "$(mise activate bash)"

echo_info 'Verify delta installation'
verify_installation delta
