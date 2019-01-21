#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install OCI CLI'
case $os_id in
  ol)
    ;;
  ubuntu)
    sudo apt -y install python3-distutils
    ;;
esac
bash -c "$(curl -L# https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
