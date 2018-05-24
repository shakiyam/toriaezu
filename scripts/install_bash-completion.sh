#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
os_version=$(. /etc/os-release; echo "$VERSION")

echo 'Install bash-completion'
case $os_id in
  ol)
    case ${os_version%%.*} in
      6)
        sudo yum -y localinstall https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
        ;;
    esac
    sudo yum -y install bash-completion
    ;;
  amzn)
    sudo yum -y install bash-completion
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install bash-completion
    ;;
esac
