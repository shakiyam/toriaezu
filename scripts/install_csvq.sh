#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo_info 'Install csvq'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
rm -f "$HOME/.local/bin/csvq" # Remove binary installed by go install in older versions
# The amd64 release binary requires GLIBC 2.34, but Oracle Linux 8 has 2.28
if [[ "$OS_ID" == "ol" && "${OS_VERSION%%.*}" == "8" && "$(uname -m)" == "x86_64" ]]; then
  echo_info 'Building from source for GLIBC compatibility on Oracle Linux 8'
  if ! command -v go &>/dev/null; then
    die "Error: Command not found: go. Run 'make install_go'."
  fi
  mise unuse --global github:mithrandie/csvq
  mise use --global go:github.com/mithrandie/csvq@latest
else
  mise unuse --global go:github.com/mithrandie/csvq
  mise use --global github:mithrandie/csvq@latest
fi
eval "$(mise activate bash)"

echo_info 'Verify csvq installation'
verify_installation csvq
