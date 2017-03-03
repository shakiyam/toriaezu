#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

# Install Git
case $os_id in
  ol | amzn)
    yum -y install git
    ;;
  ubuntu)
    apt -y install git
    ;;
esac
