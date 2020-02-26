#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install jq'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        sudo yum -y --enablerepo=ol7_addons install jq
        ;;
      8)
        sudo dnf -y install jq
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install jq
    ;;
esac
