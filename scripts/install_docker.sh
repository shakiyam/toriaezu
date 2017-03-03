#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
os_version=$(. /etc/os-release; echo "$VERSION")

# Install Docker Engine
case $os_id in
  ol)
    case ${os_version%%.*} in
      6)
        repo=$(grep -E -o '(public_)?ol6_addons' /etc/yum.repos.d/public-yum-ol6.repo)
        yum -y --enablerepo="$repo" install docker-engine
        ;;
      7)
        yum -y --enablerepo=ol7_addons install docker-engine
        ;;
    esac
    ;;
  amzn)
    yum -y install docker
    ;;
  ubuntu)
    if [ "${1:-''}" = '--latest' ]; then
      apt-get install -y --no-install-recommends \
        apt-transport-https ca-certificates curl software-properties-common
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      apt-get update
      apt-get -y install docker-ce
    else
      apt-get update
      apt-get install -y docker.io
    fi
    ;;
esac

# Setup Docker Engine
usermod -aG docker "$(logname)"
case $os_id in
  ol)
    case ${os_version%%.*} in
      6)
        service docker restart
        chkconfig docker on
        ;;
      7)
        if [ -n "${HTTP_PROXY:-}" ]; then
          mkdir -p /etc/systemd/system/docker.service.d
          cat >/etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY:-}"
EOF
        fi
        systemctl restart docker
        systemctl enable docker
        ;;
    esac
    ;;
  amzn)
    service docker restart
    chkconfig docker on
    ;;
  ubuntu)
    if [ -n "${HTTP_PROXY:-}" ]; then
      mkdir -p /etc/systemd/system/docker.service.d
      cat >/etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY:-}"
EOF
    fi
    systemctl restart docker
    systemctl enable docker
    ;;
esac
