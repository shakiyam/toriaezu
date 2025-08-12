#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install UnZip'
install_package unzip

echo_info 'Verify UnZip installation'
verify_command unzip
