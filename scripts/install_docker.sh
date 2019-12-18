#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install Docker Engine'
case $OS_ID in
  ol)
    sudo yum -y --enablerepo=ol7_addons install docker-engine
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
sudo usermod -aG docker "$(logname)"
case $OS_ID in
  ol)
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<EOF >/dev/null
{
  "selinux-enabled": false
}
EOF
    if [[ -n "${HTTP_PROXY:-}" ]]; then
      sudo mkdir -p /etc/systemd/system/docker.service.d
      sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF >/dev/null
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY:-}"
Environment="HTTPS_PROXY=${HTTP_PROXY:-}"
Environment="NO_PROXY=${NO_PROXY:-}"
EOF
    fi
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    sudo systemctl enable docker
    ;;
  ubuntu)
    if [[ -n "${HTTP_PROXY:-}" ]]; then
      sudo mkdir -p /etc/systemd/system/docker.service.d
      sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF >/dev/null
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY:-}"
Environment="HTTPS_PROXY=${HTTP_PROXY:-}"
Environment="NO_PROXY=${NO_PROXY:-}"
EOF
    fi
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    sudo systemctl enable docker
    ;;
esac
