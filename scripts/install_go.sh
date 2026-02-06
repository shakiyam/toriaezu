#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install Go Programming Language'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

# Configure GOBIN to keep go install binaries in a stable location
readonly MISE_CONFIG="$HOME/.config/mise/config.toml"
readonly GOBIN_LINE='GOBIN = "{{env.HOME}}/.local/bin"'
mkdir -p "$(dirname "$MISE_CONFIG")"
if [[ ! -f "$MISE_CONFIG" ]]; then
  echo_info 'Creating mise config with GOBIN'
  printf '[env]\n%s\n' "$GOBIN_LINE" >"$MISE_CONFIG"
elif grep -q '^GOBIN\s*=' "$MISE_CONFIG"; then
  echo_info 'GOBIN is already configured in mise config'
elif grep -q '^\[env\]' "$MISE_CONFIG"; then
  echo_info 'Adding GOBIN to existing [env] section'
  sed -i "/^\[env\]/a $GOBIN_LINE" "$MISE_CONFIG"
else
  echo_info 'Adding [env] section with GOBIN to mise config'
  printf '\n[env]\n%s\n' "$GOBIN_LINE" >>"$MISE_CONFIG"
fi

eval "$(mise activate bash)"
mise use --global go@latest
eval "$(mise activate bash)"

echo_info 'Verify Go installation'
verify_installation go
