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
    case ${OS_VERSION%%.*} in
      7)
        case $(uname -m) in
          aarch64)
            echo 'ripgrep Arm binary for Oracle Linux 7 is not available.'
            exit 0
            ;;
          x86_64)
            sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
            sudo yum -y install ripgrep
            ;;
        esac
        ;;
      8)
        sudo dnf -y --enablerepo=ol8_developer_EPEL install ripgrep
        ;;
      9)
        sudo dnf -y --enablerepo=ol9_developer_EPEL install ripgrep
        ;;
    esac
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install ripgrep
    ;;
esac
