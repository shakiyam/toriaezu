#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install dockviz'
if ! command -v mise &>/dev/null; then
  die "mise is required but not installed. Run 'make install_mise' first."
fi

eval "$(mise activate bash)"
LATEST=$(get_github_latest_release "justone/dockviz")
readonly LATEST
go install "github.com/justone/dockviz@$LATEST"

echo_info 'Verify dockviz installation'
verify_installation dockviz
