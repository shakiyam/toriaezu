#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install Git'
install_package git
git config --global user.useConfigOnly true

echo_info 'Verify Git installation'
verify_command git
