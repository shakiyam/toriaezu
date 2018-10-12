#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
os_version=$(. /etc/os-release; echo "$VERSION")

echo 'Install lv'
case $os_id in
  ol)
    case ${os_version%%.*} in
      6)
        sudo yum -y localinstall http://ftp.riken.jp/Linux/dag/redhat/el6/en/x86_64/rpmforge/RPMS/lv-4.51-1.el6.rf.x86_64.rpm
        ;;
      7)
        sudo yum -y install lv
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install lv
    ;;
esac
