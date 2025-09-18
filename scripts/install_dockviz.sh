#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install dockviz'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
LATEST=$(get_github_latest_release "justone/dockviz")
readonly LATEST
go install "github.com/justone/dockviz@$LATEST"

echo_info 'Verify dockviz installation'
verify_installation dockviz
