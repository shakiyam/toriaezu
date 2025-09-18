#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install chezmoi'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

eval "$(mise activate bash)"
mise use --global chezmoi@latest
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
