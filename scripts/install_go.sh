#!/bin/bash
set -eu -o pipefail

echo 'Install Go Programming Language'
# Check the latest version from https://golang.org/dl/
curl -L# https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz |
  sudo tar xzf - -C /usr/local
