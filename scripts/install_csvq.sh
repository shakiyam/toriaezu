#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install csvq'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
LATEST=$(get_github_latest_release "mithrandie/csvq")
readonly LATEST
go install "github.com/mithrandie/csvq@$LATEST"

echo_info 'Verify csvq installation'
verify_installation csvq
