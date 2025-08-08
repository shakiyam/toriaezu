#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install Docker Engine'
case $OS_ID in
  ol)
    install_package podman podman-plugins
    ;;
  ubuntu)
    install_package gnupg lsb-release
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
      *)
        echo_error "Unsupported architecture: $(uname -m)"
        exit 1
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
if [[ -f /.dockerenv ]] || grep -q 'docker\|lxc' /proc/1/cgroup 2>/dev/null; then
  echo_warn 'Running in container environment, skipping systemctl setup'
else
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
fi
