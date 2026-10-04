#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo_info 'Install chezmoi'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
if [[ "$OS_ID" == "ol" && "${OS_VERSION%%.*}" == "8" && "$(uname -m)" == "x86_64" ]]; then
  echo_info 'Using musl static binary for GLIBC compatibility on Oracle Linux 8'
  sudo rm -f /usr/local/bin/chezmoi # Remove binary installed by curl in older versions
  mise unuse --global chezmoi
  mise use --global "github:twpayne/chezmoi[asset_pattern=chezmoi_*_linux-musl_amd64.tar.gz]@latest"
else
  mise use --global chezmoi@latest
fi
eval "$(mise activate bash)"

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
