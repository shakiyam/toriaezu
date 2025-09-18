#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo_info 'Install chezmoi'
if [[ "$OS_ID" == "ol" && "${OS_VERSION%%.*}" == "8" && "$(uname -m)" == "x86_64" ]]; then
  echo_info 'Using musl static binary for GLIBC compatibility on Oracle Linux 8'
  LATEST=$(get_github_latest_release "twpayne/chezmoi")
  readonly LATEST
  TEMP_DIR=$(mktemp -d)
  readonly TEMP_DIR
  trap 'sudo rm -rf "$TEMP_DIR"' EXIT
  curl -fL# --proto '=https' --tlsv1.2 "https://github.com/twpayne/chezmoi/releases/download/${LATEST}/chezmoi_${LATEST#v}_linux-musl_amd64.tar.gz" \
    | sudo tar xzf - -C "$TEMP_DIR"
  sudo install -m 755 "$TEMP_DIR"/chezmoi /usr/local/bin/
else
  if ! command -v mise &>/dev/null; then
    die "Error: Command not found: mise. Run 'make install_mise'."
  fi

  eval "$(mise activate bash)"
  mise use --global chezmoi@latest
  eval "$(mise activate bash)"
fi

echo_info 'Verify chezmoi installation'
verify_installation chezmoi

echo_info 'Install chezmoi shell completions'
sudo mkdir -p /usr/share/bash-completion/completions
chezmoi completion bash | sudo install -m 644 /dev/stdin /usr/share/bash-completion/completions/chezmoi
sudo mkdir -p /usr/share/fish/vendor_completions.d
chezmoi completion fish | sudo install -m 644 /dev/stdin /usr/share/fish/vendor_completions.d/chezmoi.fish

echo_info 'Initialize and apply dotfiles'
chezmoi init https://github.com/shakiyam/dotfiles
chezmoi apply
