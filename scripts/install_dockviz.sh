#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install dockviz'
LATEST=$(get_github_latest_release "justone/dockviz")
readonly LATEST
/usr/local/go/bin/go install "github.com/justone/dockviz@$LATEST"

echo_info 'Verify dockviz installation'
verify_command dockviz
