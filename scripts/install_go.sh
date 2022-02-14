#!/bin/bash
set -eu -o pipefail

echo 'Install Go Programming Language'
VERSION=$(curl -sS https://go.dev/VERSION?m=text)
readonly VERSION
case $(uname -m) in
  x86_64)
    ARCHITECTURE=amd64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
esac
readonly ARCHITECTURE
curl -L# "https://golang.org/dl/${VERSION}.linux-${ARCHITECTURE}.tar.gz" \
  | sudo tar xzf - -C /usr/local
