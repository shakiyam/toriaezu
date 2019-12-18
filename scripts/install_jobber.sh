#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install Jobber'
readonly LATEST=$(
  curl -sSI https://github.com/dshearer/jobber/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^Location:/{print $NF}'
)
case $OS_ID in
  ol)
    sudo yum -y localinstall "https://github.com/dshearer/jobber/releases/download/${LATEST}/jobber-${LATEST#v}-1.el7.x86_64.rpm"
    sudo systemctl restart jobber
    sudo systemctl enable jobber
    ;;
  ubuntu)
    readonly DEB_FILE=$(mktemp)
    curl -L# "https://github.com/dshearer/jobber/releases/download/${LATEST}/jobber_${LATEST#v}-1_amd64.deb" -o "$DEB_FILE"
    sudo dpkg -i "$DEB_FILE"
    rm "$DEB_FILE"
    sudo systemctl restart jobber
    sudo systemctl enable jobber
    ;;
esac
