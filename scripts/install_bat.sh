#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install bat'
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
    if [ -L "$HOME/.local/bin/bat" ] && [ "$(readlink "$HOME/.local/bin/bat")" = "/usr/bin/batcat" ]; then
      echo_info "bat symlink already correctly set up"
    else
      ln -sf /usr/bin/batcat "$HOME/.local/bin/bat"
    fi
    ;;
esac
