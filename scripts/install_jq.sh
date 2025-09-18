#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install jq'
install_package jq

echo_info 'Verify jq installation'
verify_installation jq
