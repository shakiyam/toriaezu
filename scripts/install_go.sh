#!/bin/bash
set -eu -o pipefail

# Install Go Programming Language (https://golang.org/dl/)
curl -L# https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz |
  tar -C /usr/local xzf -
