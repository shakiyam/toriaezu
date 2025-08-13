#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install csvq'
LATEST=$(get_github_latest_release "mithrandie/csvq")
readonly LATEST
/usr/local/go/bin/go install "github.com/mithrandie/csvq@$LATEST"

echo_info 'Verify csvq installation'
verify_installation csvq
