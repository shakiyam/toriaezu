#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install Python3'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        sudo yum -y --enablerepo=ol7_developer_EPEL install python36
        ;;
      8)
        sudo dnf -y install python36
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install python3-venv
    ;;
esac
python3 -m venv "$HOME/python3"
# shellcheck disable=SC1090
. "$HOME/python3/bin/activate"
pip install --upgrade flake8 flake8-builtins flake8-import-order pip-tools
