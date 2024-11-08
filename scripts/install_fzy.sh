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
    curl -L# "https://github.com/jhawthorn/fzy/releases/download/${LATEST}/fzy-${LATEST}.tar.gz" \
      | tar xzf - -C "$TEMP_DIR" --strip=1
    make -C "$TEMP_DIR"
    sudo make -C "$TEMP_DIR" install
    rm -rf "$TEMP_DIR"
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install fzy
    ;;
esac
