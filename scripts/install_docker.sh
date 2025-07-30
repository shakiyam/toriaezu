#!/bin/bash
set -eu -o pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo 'Install Docker Engine'
case $OS_ID in
  ol)
    install_package podman podman-plugins
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
      ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
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
    sudo apt-get update
    install_package docker-ce
    ;;
esac

echo 'Setup Docker Engine'
if [[ ${OS_ID:-} == 'ol' ]]; then
  sudo -u "$(id -un)" XDG_RUNTIME_DIR=/run/user/"$(id -u)" systemctl --user daemon-reload
  sudo -u "$(id -un)" XDG_RUNTIME_DIR=/run/user/"$(id -u)" systemctl --user enable --now podman.socket
else
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  sudo systemctl enable docker
  LOGNAME=$(logname 2>/dev/null || id -nu)
  readonly LOGNAME
  sudo usermod -aG docker "$LOGNAME"
fi
