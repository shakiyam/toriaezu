#!/bin/bash
set -eu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install Docker Engine'
case $OS_ID in
  ol)
    install_package podman podman-plugins
    ;;
  ubuntu)
    install_package gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
    case $(uname -m) in
      x86_64)
        ARCHITECTURE=amd64
        ;;
      aarch64)
        ARCHITECTURE=arm64
        ;;
    esac
    readonly ARCHITECTURE
    echo \
      "deb [arch=$ARCHITECTURE signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo chmod 644 /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list
    install_package docker-ce
    ;;
esac

echo_info 'Setup Docker Engine'
LOGNAME="${SUDO_USER:-$(logname 2>/dev/null || id -nu)}"
readonly LOGNAME
case $OS_ID in
  ol)
    sudo -u "$LOGNAME" XDG_RUNTIME_DIR=/run/user/"$(id -u "$LOGNAME")" systemctl --user daemon-reload
    sudo -u "$LOGNAME" XDG_RUNTIME_DIR=/run/user/"$(id -u "$LOGNAME")" systemctl --user enable podman.socket
    sudo -u "$LOGNAME" XDG_RUNTIME_DIR=/run/user/"$(id -u "$LOGNAME")" systemctl --user restart podman.socket
    ;;
  ubuntu)
    sudo systemctl daemon-reload
    sudo systemctl enable docker
    sudo systemctl restart docker
    sudo usermod -aG docker "$LOGNAME"
    ;;
esac
