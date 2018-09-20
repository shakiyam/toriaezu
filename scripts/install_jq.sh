#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
os_version=$(. /etc/os-release; echo "$VERSION")

echo 'Install jq'
case $os_id in
  ol)
    case ${os_version%%.*} in
      6)
        repo=$(grep -E -o '(public_)?ol6_addons' /etc/yum.repos.d/public-yum-ol6.repo)
        sudo yum -y --enablerepo="$repo" jq
        ;;
      7)
        sudo yum -y --enablerepo=ol7_addons install jq
        ;;
    esac
    ;;
  amzn)
    sudo yum -y install jq
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install jq
    ;;
esac
