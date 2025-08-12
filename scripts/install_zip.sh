#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install Zip'
install_package zip

echo_info 'Verify Zip installation'
verify_command zip
