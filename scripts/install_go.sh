#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install Go Programming Language'
VERSION=$(curl -sS https://go.dev/VERSION?m=text | head -n 1)
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
