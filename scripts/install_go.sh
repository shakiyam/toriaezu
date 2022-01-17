#!/bin/bash
set -eu -o pipefail

echo 'Install Go Programming Language'
# Check the latest version from https://golang.org/dl/
case $(uname -m) in
  x86_64)
    ARCHITECTURE=amd64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
esac
readonly ARCHITECTURE
curl -L# https://golang.org/dl/go1.17.6.linux-${ARCHITECTURE}.tar.gz \
  | sudo tar xzf - -C /usr/local
