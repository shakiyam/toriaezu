#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install OCI CLI'
case $OS_ID in
  ol)
    ;;
  ubuntu)
    sudo apt -y install python3-distutils
    ;;
esac
bash -c "$(curl -L# https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
