#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

# Install Make
case $OS_ID in
  ol)
    sudo yum -y install make
    [[ -e /usr/bin/ol_yum_configure.sh ]] && sudo /usr/bin/ol_yum_configure.sh && sudo yum install oracle-epel-release-el7.x86_64
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install make
    ;;
esac

make toriaezu
