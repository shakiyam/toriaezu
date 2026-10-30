#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install Node.js'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

# Node.js binaries need libatomic, which minimal images do not include
echo_info 'Install Node.js dependencies'
case $OS_ID in
  ol)
    install_package libatomic
    ;;
  ubuntu)
    install_package libatomic1
    ;;
esac

eval "$(mise activate bash)"
mise use --global node@lts
eval "$(mise activate bash)"

echo_info 'Verify Node.js installation'
verify_installation node
verify_installation npm
