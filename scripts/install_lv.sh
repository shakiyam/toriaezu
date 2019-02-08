#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install lv'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      6)
        sudo yum -y localinstall http://ftp.riken.jp/Linux/dag/redhat/el6/en/x86_64/rpmforge/RPMS/lv-4.51-1.el6.rf.x86_64.rpm
        ;;
      7)
        sudo yum -y --enablerepo=ol7_developer_EPEL install lv
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install lv
    ;;
esac
