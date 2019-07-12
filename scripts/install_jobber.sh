#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install Jobber'
readonly LATEST=$(
  curl -sSI https://github.com/dshearer/jobber/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^Location:/{print $NF}'
)
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      6)
        sudo yum -y localinstall https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm \
          "https://github.com/dshearer/jobber/releases/download/v1.3.4/jobber-1.3.4-1.el6.x86_64.rpm"
        sudo service jobber restart
        sudo chkconfig jobber on
        ;;
      7)
        sudo yum -y localinstall "https://github.com/dshearer/jobber/releases/download/${LATEST}/jobber-${LATEST#v}-1.el7.x86_64.rpm"
        sudo systemctl restart jobber
        sudo systemctl enable jobber
        ;;
    esac
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
