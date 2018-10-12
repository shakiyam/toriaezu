#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
os_version=$(. /etc/os-release; echo "$VERSION")

echo 'Install Ruby'
case $os_id in
  ol)
    case ${os_version%%.*} in
      6)
        curl -ssL http://yum.oracle.com/public-yum-ol6.repo \
          | sudo tee /etc/yum.repos.d/public-yum-ol6.repo >/dev/null
        sudo yum -y --enablerepo=ol6_software_collections install rh-ruby23
        ;;
      7)
        sudo yum -y --enablerepo=ol7_software_collections install rh-ruby23
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install ruby
    ;;
esac
