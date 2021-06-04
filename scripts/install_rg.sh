#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID

echo 'Install ripgrep'
case $OS_ID in
  ol)
    if [[ $(uname -m) == 'aarch64' ]]; then
      echo 'ripgrep is not yet available as an ARM binary.'
      exit 0
    fi
    sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
    sudo yum -y install ripgrep
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install ripgrep
    ;;
esac
