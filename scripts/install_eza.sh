#!/bin/bash
set -eu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install eza'
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

    LATEST=$(get_github_latest_release "eza-community/eza")
    readonly LATEST

    curl -L# "https://github.com/eza-community/eza/releases/download/${LATEST}/eza_${ARCHITECTURE}.tar.gz" \
      | sudo tar xzf - -C /usr/local/bin/
    sudo chmod +x /usr/local/bin/eza
    ;;
  ubuntu)
    install_package gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
      | sudo gpg --yes --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
      | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    install_package eza
    ;;
esac
