#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo_info 'Install zizmor'
if [[ "$OS_ID" == "ol" && "${OS_VERSION%%.*}" == "8" ]]; then
  echo_warn 'zizmor is not supported on Oracle Linux 8 (requires GLIBC 2.29 or later)'
  exit 0
fi
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
mise use --global zizmor@latest
eval "$(mise activate bash)"

echo_info 'Verify zizmor installation'
verify_installation zizmor
