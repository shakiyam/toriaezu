#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install fzy'
case $os_id in
  ol)
    sudo yum -y install gcc git make
    temp_dir=$(mktemp -d)
    pushd "$temp_dir"
    git clone https://github.com/jhawthorn/fzy
    cd fzy
    make
    sudo make install
    popd
    rm -rf "$temp_dir"
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install fzy
    ;;
esac
