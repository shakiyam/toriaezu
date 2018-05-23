#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install bash-completion'
case $os_id in
  ol | amzn)
    sudo yum -y install bash-completion
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install bash-completion
    ;;
esac
