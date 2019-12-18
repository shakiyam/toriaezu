#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install jq'
case $OS_ID in
  ol)
    sudo yum -y --enablerepo=ol7_addons install jq
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install jq
    ;;
esac
