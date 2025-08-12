#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install tmux'
install_package tmux

echo_info 'Verify tmux installation'
verify_installation tmux
