#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install bash-completion'
case $OS_ID in
  ol)
    sudo yum -y install bash-completion
    sudo yum -y --enablerepo=ol7_developer_EPEL install bash-completion-extras
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install bash-completion
    ;;
esac
