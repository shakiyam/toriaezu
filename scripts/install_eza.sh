#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

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
      *)
        echo_error "Unsupported architecture: $(uname -m)"
        exit 1
        ;;
    esac
    readonly ARCHITECTURE

    LATEST=$(get_github_latest_release "eza-community/eza")
    readonly LATEST

    curl -fL# "https://github.com/eza-community/eza/releases/download/${LATEST}/eza_${ARCHITECTURE}.tar.gz" \
      | tar xzf - -O ./eza | sudo install -m 755 /dev/stdin /usr/local/bin/eza
    ;;
  ubuntu)
    install_package gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
      | sudo gpg --yes --dearmor -o /etc/apt/keyrings/gierens.gpg
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
      | sudo install -m 644 /dev/stdin /etc/apt/sources.list.d/gierens.list
    install_package eza
    ;;
esac
