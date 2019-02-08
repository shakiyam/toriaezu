#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install bash-completion'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      6)
        sudo yum -y localinstall https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
        sudo yum -y install bash-completion
        ;;
      7)
        sudo yum -y install bash-completion
        sudo yum -y --enablerepo=ol7_developer_EPEL install bash-completion-extras
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install bash-completion
    ;;
esac
