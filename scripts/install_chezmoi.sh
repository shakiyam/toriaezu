#!/bin/bash
set -eu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

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
esac
readonly ARCHITECTURE
TEMP_DIR=$(mktemp -d)
readonly TEMP_DIR
curl -L# "https://github.com/twpayne/chezmoi/releases/download/${LATEST}/chezmoi_${LATEST#v}_linux_${ARCHITECTURE}.tar.gz" \
  | sudo tar xzf - -C "$TEMP_DIR"
sudo cp "$TEMP_DIR"/chezmoi /usr/local/bin/
sudo cp "$TEMP_DIR"/completions/chezmoi-completion.bash /usr/share/bash-completion/completions/chezmoi
sudo rm -rf "$TEMP_DIR"
/usr/local/bin/chezmoi init https://github.com/shakiyam/dotfiles
/usr/local/bin/chezmoi apply
