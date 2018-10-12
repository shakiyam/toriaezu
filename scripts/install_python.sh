#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
os_version=$(. /etc/os-release; echo "$VERSION")

echo 'Install Python'
case $os_id in
  ol)
    case ${os_version%%.*} in
      6)
        curl -ssL http://yum.oracle.com/public-yum-ol6.repo |
          sudo tee /etc/yum.repos.d/public-yum-ol6.repo >/dev/null
        sudo yum -y --enablerepo=ol6_software_collections install rh-python35
        ;;
      7)
        sudo yum -y --enablerepo=ol7_optional_latest,ol7_software_collections install rh-python35
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install python3-venv
    python3 -m venv "/home/$(logname)"
    ;;
esac
