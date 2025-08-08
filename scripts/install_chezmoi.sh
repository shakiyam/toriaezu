#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install chezmoi'
LATEST=$(get_github_latest_release "twpayne/chezmoi")
readonly LATEST
case $(uname -m) in
  x86_64)
    ARCHITECTURE=amd64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
  *)
    echo_error "Unsupported architecture: $(uname -m)"
    exit 1
    ;;
esac
readonly ARCHITECTURE
TEMP_DIR=$(mktemp -d)
readonly TEMP_DIR
trap 'sudo rm -rf "$TEMP_DIR"' EXIT
curl -L# "https://github.com/twpayne/chezmoi/releases/download/${LATEST}/chezmoi_${LATEST#v}_linux_${ARCHITECTURE}.tar.gz" \
  | sudo tar xzf - -C "$TEMP_DIR"
sudo cp "$TEMP_DIR"/chezmoi /usr/local/bin/
sudo cp "$TEMP_DIR"/completions/chezmoi-completion.bash /usr/share/bash-completion/completions/chezmoi
/usr/local/bin/chezmoi init https://github.com/shakiyam/dotfiles
/usr/local/bin/chezmoi apply
