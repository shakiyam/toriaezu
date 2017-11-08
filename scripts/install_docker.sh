#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
os_version=$(. /etc/os-release; echo "$VERSION")

echo 'Install Docker Engine'
case $os_id in
  ol)
    case ${os_version%%.*} in
      6)
        repo=$(grep -E -o '(public_)?ol6_addons' /etc/yum.repos.d/public-yum-ol6.repo)
        sudo yum -y --enablerepo="$repo" install docker-engine
        ;;
      7)
        sudo yum -y --enablerepo=ol7_addons install docker-engine
        ;;
    esac
    ;;
  amzn)
    sudo yum -y install docker
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
case $os_id in
  ol)
    case ${os_version%%.*} in
      6)
        if [ -n "${HTTP_PROXY:-}" ]; then
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
        sudo sed -i 's/.*--selinux-enabled/#&/g' /etc/sysconfig/docker
        if [ -n "${HTTP_PROXY:-}" ]; then
          sudo mkdir -p /etc/systemd/system/docker.service.d
          sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF >/dev/null
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY:-}"
Environment="HTTPS_PROXY=${HTTP_PROXY:-}"
Environment="NO_PROXY=${NO_PROXY:-}"
EOF
        fi
        sudo systemctl restart docker
        sudo systemctl enable docker
        ;;
    esac
    ;;
  amzn)
    sudo service docker restart
    sudo chkconfig docker on
    ;;
  ubuntu)
    if [ -n "${HTTP_PROXY:-}" ]; then
      sudo mkdir -p /etc/systemd/system/docker.service.d
      sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF >/dev/null
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY:-}"
Environment="HTTPS_PROXY=${HTTP_PROXY:-}"
Environment="NO_PROXY=${NO_PROXY:-}"
EOF
    fi
    sudo systemctl restart docker
    sudo systemctl enable docker
    ;;
esac
