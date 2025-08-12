#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install Claude Code'
sudo npm install -g @anthropic-ai/claude-code

echo_info 'Verify Claude Code installation'
verify_command claude
