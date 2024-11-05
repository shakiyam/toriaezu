#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(
  . /etc/os-release
  echo "$VERSION"
)
readonly OS_VERSION

echo 'Install jq'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        sudo yum -y install jq
        ;;
      8)
        sudo dnf -y install jq
        ;;
      9)
        sudo dnf -y install jq
        ;;
    esac
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install jq
    ;;
esac
