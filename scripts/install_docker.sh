#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
os_version=$(. /etc/os-release; echo "$VERSION")

# Install Docker Engine
if [ "${1:-''}" = '--latest' ]; then
  case $os_id in
    ol)
      yum -y install yum-utils
      yum-config-manager --add-repo \
        https://docs.docker.com/engine/installation/linux/repo_files/oracle/docker-ol7.repo
      yum makecache fast
      yum -y install docker-engine
      ;;
    amzn)
      yum -y install docker
      ;;
    ubuntu)
      apt-get install -y --no-install-recommends \
        apt-transport-https ca-certificates curl software-properties-common
      curl -fsSL https://apt.dockerproject.org/gpg | apt-key add -
      add-apt-repository \
        "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main"
      apt-get update
      apt-get -y install docker-engine
      ;;
  esac
else
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
      apt-get update
      apt-get install -y docker.io
      ;;
  esac
fi

# Setup Docker Engine
usermod -aG docker "$(logname)"
case $os_id in
  ol)
    case ${os_version%%.*} in
      6)
        service docker start
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
        systemctl start docker
        systemctl enable docker
        ;;
    esac
    ;;
  amzn)
    service docker start
    chkconfig docker on
    ;;
  ubuntu)
    systemctl start docker
    systemctl enable docker
    ;;
esac
