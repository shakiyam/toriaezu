#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(
  . /etc/os-release
  echo "$VERSION"
)
readonly OS_VERSION

echo 'Install Docker Engine'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        case $(uname -m) in
          x86_64)
            sudo yum -y --enablerepo ol7_addons install docker-engine
            ;;
          aarch64)
            sudo yum -y --enablerepo ol7_developer install docker-engine
            ;;
        esac
        ;;
      8)
        sudo dnf -y install podman podman-plugins
        ;;
      9)
        sudo dnf -y install podman podman-plugins
        ;;
    esac
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
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install docker-ce
    ;;
esac

echo 'Setup Docker Engine'
if [[ ${OS_ID:-} == 'ol' && ${OS_VERSION%%.*} -ge 8 ]]; then
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
