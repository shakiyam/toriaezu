#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install mise'
curl -fsSL --proto '=https' --tlsv1.2 https://mise.jdx.dev/install.sh | sh
eval "$(mise activate bash)"

echo_info 'Verify mise installation'
verify_installation mise
