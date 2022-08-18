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

echo 'Install ripgrep'
case $OS_ID in
  ol)
    if [[ $(uname -m) == 'aarch64' ]]; then
      echo 'ripgrep is not yet available as an ARM binary.'
      exit 0
    fi
    case ${OS_VERSION%%.*} in
      7)
        sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
        sudo yum -y install ripgrep
        ;;
      8)
        sudo dnf config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
        sudo dnf -y install ripgrep
        ;;
      9)
        echo 'ripgrep is not yet supported on Oracle Linux 9.'
        exit 0
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install ripgrep
    ;;
esac
