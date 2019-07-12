#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install Ruby'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      6)
        curl -ssL http://yum.oracle.com/public-yum-ol6.repo \
          | sudo tee /etc/yum.repos.d/public-yum-ol6.repo >/dev/null
        sudo yum -y --enablerepo=ol6_software_collections install rh-ruby24
        ;;
      7)
        sudo yum -y --enablerepo=ol7_software_collections install rh-ruby24
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install ruby
    ;;
esac
