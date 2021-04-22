#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(. /etc/os-release; echo "$ID"); readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(. /etc/os-release; echo "$VERSION"); readonly OS_VERSION

echo 'Install Ruby'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        sudo yum -y install oracle-softwarecollection-release-el7
        sudo yum -y --enablerepo=ol7_software_collections install rh-ruby26
        ;;
      8)
        sudo dnf -y install @ruby:2.6
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install ruby
    ;;
esac
