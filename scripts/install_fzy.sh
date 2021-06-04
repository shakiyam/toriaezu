#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID

echo 'Install fzy'
case $OS_ID in
  ol)
    sudo yum -y install gcc
    TEMP_DIR=$(mktemp -d)
    readonly TEMP_DIR
    LATEST=$(
      curl -sSI https://github.com/jhawthorn/fzy/releases/latest \
        | tr -d '\r' \
        | awk -F'/' '/^[Ll]ocation:/{print $NF}'
    )
    readonly LATEST
    curl -L# "https://github.com/jhawthorn/fzy/releases/download/1.0/fzy-${LATEST}.tar.gz" \
      | tar xzf - -C "$TEMP_DIR" --strip=1
    make -C "$TEMP_DIR"
    sudo make -C "$TEMP_DIR" install
    rm -rf "$TEMP_DIR"
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install fzy
    ;;
esac
