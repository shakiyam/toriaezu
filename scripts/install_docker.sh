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
  sudo mkdir -p /etc/systemd/system/docker.service.d
  if [[ -n "${HTTP_PROXY:-}" ]]; then
    sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF >/dev/null
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY:-}"
Environment="HTTPS_PROXY=${HTTP_PROXY:-}"
Environment="NO_PROXY=${NO_PROXY:-}"
EOF
  else
    sudo cp /dev/null /etc/systemd/system/docker.service.d/http-proxy.conf
  fi
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  sudo systemctl enable docker
  LOGNAME=$(logname 2>/dev/null || id -nu)
  readonly LOGNAME
  sudo usermod -aG docker "$LOGNAME"
  mkdir -p "/home/$LOGNAME/.docker"
  readonly CONFIG_JSON="/home/$LOGNAME/.docker/config.json"
  readonly CONFIG_BAKUP_JSON="/home/$LOGNAME/.docker/config_backup.json"
  readonly PROXIES_JSON="/home/$LOGNAME/.docker/proxies.json"

  if [[ -e "$CONFIG_JSON" ]]; then
    jq 'del(.proxies)' "$CONFIG_JSON" >"$CONFIG_BAKUP_JSON"
  else
    echo {} >"$CONFIG_BAKUP_JSON"
  fi
  if [[ -n "${HTTP_PROXY:-}" ]]; then
    cat <<EOF >"$PROXIES_JSON"
{
  "proxies":
  {
    "default":
    {
      "httpProxy": "${HTTP_PROXY:-}",
      "httpsProxy": "${HTTPS_PROXY:-}",
      "noProxy": "${NO_PROXY:-}"
    }
  }
}
EOF
  else
    echo {} >"$PROXIES_JSON"
  fi
  jq -s '.[0]+.[1]' "$CONFIG_BAKUP_JSON" "$PROXIES_JSON" >"$CONFIG_JSON"
fi
