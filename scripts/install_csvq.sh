#!/bin/bash
set -eu -o pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

echo 'Install csvq'
LATEST=$(get_github_latest_release "mithrandie/csvq")
readonly LATEST
/usr/local/go/bin/go install "github.com/mithrandie/csvq@$LATEST"
