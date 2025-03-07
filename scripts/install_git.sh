#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID

echo 'Install Git'
readonly GIT_CONFIG='git config --global user.useConfigOnly true'
case $OS_ID in
  ol)
    sudo dnf -y install git
    $GIT_CONFIG
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install git
    $GIT_CONFIG
    ;;
esac
