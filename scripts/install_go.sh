#!/bin/bash
set -eu -o pipefail

echo 'Install Go Programming Language'
# Check the latest version from https://golang.org/dl/
curl -L# https://golang.org/dl/go1.15.5.linux-amd64.tar.gz \
  | sudo tar xzf - -C /usr/local
