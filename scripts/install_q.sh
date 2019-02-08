#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install Q'
# Check the latest version from http://harelba.github.io/q/install.html
case $OS_ID in
  ol)
    sudo yum -y localinstall https://github.com/harelba/packages-for-q/raw/master/rpms/q-text-as-data-1.7.1-1.noarch.rpm
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install python-minimal
    FILE=$(mktemp)
    curl -L# https://github.com/harelba/packages-for-q/raw/master/deb/q-text-as-data_1.7.1-2_all.deb -o "$FILE"
    sudo dpkg -i "$FILE"
    rm "$FILE"
    ;;
esac
sudo sed -i -e 1s/python$/python2/ "$(command -v q)"
