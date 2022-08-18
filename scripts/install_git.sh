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

echo 'Install Git'
readonly GIT_CONFIG='git config --global user.useConfigOnly true'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        sudo yum -y install rh-git218
        scl enable rh-git218 "$GIT_CONFIG"
        ;;
      8)
        sudo dnf -y install git
        $GIT_CONFIG
        ;;
      9)
        sudo dnf -y install git
        $GIT_CONFIG
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install git
    $GIT_CONFIG
    ;;
esac
