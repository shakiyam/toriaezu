#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

# Install Go Programming Language
case $os_id in
  ol | amzn)
    curl -sSL https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz |
      tar xzf - -C /usr/local
    ;;
  ubuntu)
    apt-get install -y golang
    ;;
esac
