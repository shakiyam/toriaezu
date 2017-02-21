#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

# Install Q (http://harelba.github.io/q/install.html)
case $os_id in
  ol | amzn)
    rpm -ivh https://github.com/harelba/packages-for-q/raw/master/rpms/q-text-as-data-1.5.0-1.noarch.rpm
    ;;
  ubuntu)
    apt-get install -y python-minimal
    FILE=$(mktemp)
    curl -sSL https://github.com/harelba/packages-for-q/raw/master/deb/q-text-as-data_1.5.0-1_all.deb -o "$FILE"
    dpkg -i "$FILE"
    rm "$FILE"
    ;;
esac
