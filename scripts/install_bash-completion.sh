#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(. /etc/os-release; echo "$ID"); readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(. /etc/os-release; echo "$VERSION"); readonly OS_VERSION

echo 'Install bash-completion'
case $OS_ID in
  ol)
    sudo yum -y install bash-completion
    if [[ "${OS_VERSION%%.*}" -eq 7 ]]; then
      sudo yum install oracle-epel-release-el7.x86_64
      sudo yum -y --enablerepo=ol7_developer_EPEL install bash-completion-extras
    fi
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install bash-completion
    ;;
esac
