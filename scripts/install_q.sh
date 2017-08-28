#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install Q'
# Check the latest version from http://harelba.github.io/q/install.html
case $os_id in
  ol | amzn)
    sudo rpm -ivh https://github.com/harelba/packages-for-q/raw/master/rpms/q-text-as-data-1.6.3-1.noarch.rpm
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install python-minimal
    FILE=$(mktemp)
    curl -L# https://github.com/harelba/packages-for-q/raw/master/deb/q-text-as-data_1.6.3-2_all.deb -o "$FILE"
    sudo dpkg -i "$FILE"
    rm "$FILE"
    ;;
esac
