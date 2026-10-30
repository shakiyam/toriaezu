#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install herdr'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
if [[ -f "$HOME/.local/bin/herdr" ]]; then
  echo_info 'Removing herdr installed by the official installer'
  rm -f "$HOME/.local/bin/herdr"
fi
# Unlike the other tools, set a postinstall that keeps the Claude Code hook matching
# the herdr version whenever mise installs a new herdr
# shellcheck disable=SC2016 # The shell that runs the postinstall expands the variables
mise use --global 'herdr[postinstall=if [ -d "$HOME/.claude" ]; then "$MISE_TOOL_INSTALL_PATH/herdr" integration install claude; fi]@latest'
eval "$(mise activate bash)"

echo_info 'Verify herdr installation'
verify_installation herdr

echo_info 'Install herdr Claude Code integration'
# Install it here too, because the postinstall does not run when herdr is already installed
if [[ -d "$HOME/.claude" ]]; then
  herdr integration install claude
else
  echo_info "Skipped: $HOME/.claude not found"
fi

echo_info 'Install herdr fish completions'
mkdir -p "$HOME/.config/fish/completions"
herdr completion fish >"$HOME/.config/fish/completions/herdr.fish"
