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
mise use --global herdr@latest
eval "$(mise activate bash)"

echo_info 'Verify herdr installation'
verify_installation herdr

echo_info 'Install herdr Claude Code integration'
if [[ -d "$HOME/.claude" ]]; then
  herdr integration install claude
else
  echo_info "Skipped: $HOME/.claude not found"
fi

echo_info 'Install herdr fish completions'
mkdir -p "$HOME/.config/fish/completions"
herdr completion fish >"$HOME/.config/fish/completions/herdr.fish"
