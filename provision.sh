#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

# Install Make
case $os_id in
  ol | amzn)
    yum -y install make
    ;;
  ubuntu)
    apt update
    apt -y install make
    ;;
esac

make toriaezu
