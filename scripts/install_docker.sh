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
      apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    case $(uname -m) in
      x86_64)
        ARCHITECTURE=amd64
        ;;
      aarch64)
        ARCHITECTURE=arm64
        ;;
    esac
    readonly ARCHITECTURE
    sudo add-apt-repository -y \
      "deb [arch=$ARCHITECTURE] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
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
