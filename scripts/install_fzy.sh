#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install fzy'
case $OS_ID in
  ol)
    sudo yum -y install gcc
    temp_dir=$(mktemp -d)
    pushd "$temp_dir"
    readonly LATEST=$(
      curl -sSI https://github.com/jhawthorn/fzy/releases/latest \
        | tr -d '\r' \
        | awk -F'/' '/^[Ll]ocation:/{print $NF}'
    )
    curl -L# "https://github.com/jhawthorn/fzy/releases/download/1.0/fzy-${LATEST}.tar.gz" \
      | tar xzf -
    cd "fzy-${LATEST}"
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
