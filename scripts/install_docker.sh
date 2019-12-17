#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install Docker Engine'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      6)
        repo=$(yum repolist | grep -E -o '(public_)?ol6_addons')
        sudo yum -y --enablerepo="$repo" install docker-engine
        ;;
      7)
        sudo yum -y --enablerepo=ol7_addons install docker-engine
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
sudo usermod -aG docker "$(logname)"
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      6)
        if [[ -n "${HTTP_PROXY:-}" ]]; then
          sudo tee -a /etc/sysconfig/docker <<EOF >/dev/null
export HTTP_PROXY="${HTTP_PROXY:-}"
export HTTPS_PROXY="${HTTP_PROXY:-}"
export NO_PROXY="${NO_PROXY:-}"
EOF
        fi
        sudo service docker restart
        sudo chkconfig docker on
        ;;
      7)
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
    esac
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
