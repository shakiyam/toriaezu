#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(. /etc/os-release; echo "$ID"); readonly OS_ID

echo 'Install Jobber'
LATEST=$(
  curl -sSI https://github.com/dshearer/jobber/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
case $OS_ID in
  ol)
    sudo yum -y localinstall "https://github.com/dshearer/jobber/releases/download/${LATEST}/jobber-${LATEST#v}-1.el8.x86_64.rpm"
    sudo systemctl restart jobber
    sudo systemctl enable jobber
    ;;
  ubuntu)
    DEB_FILE=$(mktemp); readonly DEB_FILE
    curl -L# "https://github.com/dshearer/jobber/releases/download/${LATEST}/jobber_${LATEST#v}-1_amd64.deb" -o "$DEB_FILE"
    sudo dpkg -i "$DEB_FILE"
    rm "$DEB_FILE"
    sudo systemctl restart jobber
    sudo systemctl enable jobber
    ;;
esac
