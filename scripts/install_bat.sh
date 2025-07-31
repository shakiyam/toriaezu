#!/bin/bash
set -eu -o pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo 'Install bat'
case $OS_ID in
  ol)
    case $(uname -m) in
      x86_64)
        ARCHITECTURE=x86_64-unknown-linux-gnu
        ;;
      aarch64)
        ARCHITECTURE=aarch64-unknown-linux-gnu
        ;;
    esac
    readonly ARCHITECTURE

    LATEST=$(get_github_latest_release "sharkdp/bat")
    readonly LATEST

    curl -L# "https://github.com/sharkdp/bat/releases/download/${LATEST}/bat-${LATEST}-${ARCHITECTURE}.tar.gz" \
      | sudo tar xzf - -C /usr/local/bin/ --strip=1 "bat-${LATEST}-${ARCHITECTURE}/bat"
    sudo chmod +x /usr/local/bin/bat
    ;;
  ubuntu)
    install_package bat
    mkdir -p "$HOME"/.local/bin
    ln -s /usr/bin/batcat "$HOME/.local/bin/bat"
    ;;
esac
