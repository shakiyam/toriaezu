#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(. /etc/os-release; echo "$ID"); readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(. /etc/os-release; echo "$VERSION"); readonly OS_VERSION

echo 'Install Docker Engine'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        sudo yum -y install docker-engine
        ;;
      8)
        sudo dnf -y install podman
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install --no-install-recommends \
      apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt -y install docker-ce
    ;;
esac

echo 'Setup Docker Engine'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        sudo usermod -aG docker "$(logname)"
        sudo mkdir -p /etc/docker
        if [[ -n "${HTTP_PROXY:-}" ]]; then
          sudo mkdir -p /etc/systemd/system/docker.service.d
          sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF >/dev/null
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY:-}"
Environment="HTTPS_PROXY=${HTTP_PROXY:-}"
Environment="NO_PROXY=${NO_PROXY:-}"
EOF
          LOGNAME=$(logname 2> /dev/null || id -nu); readonly LOGNAME
          mkdir -p "/home/$LOGNAME/.docker"
          cat <<EOF >"/home/$LOGNAME/.docker/config.json"
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
        fi
        sudo systemctl daemon-reload
        sudo systemctl restart docker
        sudo systemctl enable docker
        ;;
      8)
        ;;
    esac
    ;;
  ubuntu)
    sudo usermod -aG docker "$(logname)"
    if [[ -n "${HTTP_PROXY:-}" ]]; then
      sudo mkdir -p /etc/systemd/system/docker.service.d
      sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF >/dev/null
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY:-}"
Environment="HTTPS_PROXY=${HTTP_PROXY:-}"
Environment="NO_PROXY=${NO_PROXY:-}"
EOF
      LOGNAME=$(logname 2> /dev/null || id -nu); readonly LOGNAME
      mkdir -p "/home/$LOGNAME/.docker"
      cat <<EOF >"/home/$LOGNAME/.docker/config.json"
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
    fi
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    sudo systemctl enable docker
    ;;
esac
