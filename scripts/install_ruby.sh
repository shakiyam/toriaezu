#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install Ruby'
case $OS_ID in
  ol)
    sudo yum -y install oracle-softwarecollection-release-el7
    sudo yum -y --enablerepo=ol7_software_collections install rh-ruby26
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install ruby
    ;;
esac
