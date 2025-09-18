#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install mise'
curl -fsSL https://mise.jdx.dev/install.sh | sh

# Add to PATH for current session
export PATH="$HOME/.local/bin:$PATH"

# Setup shell integration for Bash
if [ -f "$HOME/.bashrc" ]; then
  if ! grep -q 'mise activate bash' "$HOME/.bashrc" 2>/dev/null; then
    # shellcheck disable=SC2016
    echo 'eval "$(mise activate bash)"' >>"$HOME/.bashrc"
    echo_info 'Added mise activation to ~/.bashrc'
  fi
fi

# Setup shell integration for Fish if installed
if command -v fish &>/dev/null; then
  FISH_CONFIG="$HOME/.config/fish/config.fish"
  if [ -f "$FISH_CONFIG" ]; then
    if ! grep -q 'mise activate fish' "$FISH_CONFIG" 2>/dev/null; then
      echo 'mise activate fish | source' >>"$FISH_CONFIG"
      echo_info 'Added mise activation to Fish config'
    fi
  fi
fi

echo_info 'Verify mise installation'
if [ -x "$HOME/.local/bin/mise" ]; then
  "$HOME/.local/bin/mise" --version
else
  die "Failed to install mise"
fi
