#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION
LOGNAME="${SUDO_USER:-$(logname 2>/dev/null || id -nu)}"
readonly LOGNAME

echo_info 'Install Docker Engine'
case $OS_ID in
  ol)
    install_package podman podman-plugins netavark aardvark-dns
    ;;
  ubuntu)
    install_package gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL --proto '=https' --tlsv1.2 https://download.docker.com/linux/ubuntu/gpg \
      | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod 644 /etc/apt/keyrings/docker.gpg
    case $(uname -m) in
      x86_64)
        ARCHITECTURE=amd64
        ;;
      aarch64)
        ARCHITECTURE=arm64
        ;;
      *)
        die "Error: Unsupported architecture: $(uname -m)"
        ;;
    esac
    readonly ARCHITECTURE
    # Remove first: uutils install fails to overwrite from /dev/stdin (uutils/coreutils#11532)
    sudo rm -f /etc/apt/sources.list.d/docker.list
    echo "deb [arch=$ARCHITECTURE signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
      | sudo install -m 644 /dev/stdin /etc/apt/sources.list.d/docker.list
    install_package docker-ce
    ;;
esac

if [[ $OS_ID == ol ]]; then
  # CNI, the default on Oracle Linux 8, orders DNS servers randomly for containers on multiple networks (podman#14262)
  echo_info 'Configure Podman network backend'
  if ! is_container && [[ $(sudo -u "$LOGNAME" XDG_RUNTIME_DIR=/run/user/"$(id -u "$LOGNAME")" podman info --format '{{.Host.NetworkBackend}}') == cni ]]; then
    echo_warn 'Switching Podman from CNI to netavark; existing CNI networks and containers stop working'
    echo_warn 'Run "podman system reset" to finish the switch (it deletes all images, containers, volumes, and networks)'
  fi
  sudo mkdir -p /etc/containers/containers.conf.d
  printf '[network]\nnetwork_backend = "netavark"\n' \
    | sudo install -m 644 /dev/stdin /etc/containers/containers.conf.d/50-netavark.conf

  case ${OS_VERSION%%.*} in
    8)
      # cgroup v1 by default, where rootless Podman cannot apply resource limits
      ;;
    9)
      # Only memory and pids are delegated by default, so rootless Podman cannot apply CPU limits
      echo_info 'Delegate cgroup controllers to users'
      sudo mkdir -p /etc/systemd/system/user@.service.d
      printf '[Service]\nDelegate=cpu cpuset io memory pids\n' \
        | sudo install -m 644 /dev/stdin /etc/systemd/system/user@.service.d/delegate.conf
      if ! is_container; then
        sudo systemctl daemon-reload
        LOGNAME_UID=$(id -u "$LOGNAME")
        readonly LOGNAME_UID
        if ! grep -qsw cpu "/sys/fs/cgroup/user.slice/user-$LOGNAME_UID.slice/user@$LOGNAME_UID.service/cgroup.controllers"; then
          echo_warn "Log out all sessions of $LOGNAME or reboot to delegate the cgroup controllers"
        fi
      fi
      ;;
    *)
      die "Error: Unknown Oracle Linux version: $OS_VERSION"
      ;;
  esac
fi

echo_info 'Setup Docker Engine'
if is_container; then
  echo_warn 'Running in container environment, skipping systemctl setup'
else
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

echo_info 'Verify Docker installation'
case $OS_ID in
  ol)
    verify_installation podman
    if ! is_container; then
      NETWORK_BACKEND=$(sudo -u "$LOGNAME" XDG_RUNTIME_DIR=/run/user/"$(id -u "$LOGNAME")" podman info --format '{{.Host.NetworkBackend}}')
      readonly NETWORK_BACKEND
      if [[ $NETWORK_BACKEND != netavark ]]; then
        die "Error: Podman uses $NETWORK_BACKEND instead of netavark"
      fi
    fi
    ;;
  ubuntu)
    verify_installation docker
    ;;
esac

if [[ $(uname -m) == "aarch64" ]] && ! is_container; then
  echo_info 'Setup multi-architecture support for ARM64 hosts'
  case $OS_ID in
    ol)
      echo_warn 'Multi-arch emulation (AMD64 on ARM64) is not supported on Oracle Linux'
      echo_warn 'Use native ARM64 containers or consider using Ubuntu for cross-platform support'
      ;;
    ubuntu)
      echo_info 'Enable multi-arch emulation for Docker'
      case ${OS_VERSION%%.*} in
        24)
          install_package qemu-user-static binfmt-support
          ;;
        26)
          install_package qemu-user-binfmt
          ;;
        *)
          die "Error: Unknown Ubuntu version: $OS_VERSION"
          ;;
      esac
      sudo systemctl restart systemd-binfmt
      echo_info 'Multi-architecture support enabled for AMD64 containers on ARM64'
      ;;
  esac
fi
