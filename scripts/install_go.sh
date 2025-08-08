#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install Go Programming Language'
VERSION=$(curl -fsSL https://go.dev/VERSION?m=text | head -n 1) || {
  echo_error "Failed to fetch Go version"
  exit 1
}
readonly VERSION
case $(uname -m) in
  x86_64)
    ARCHITECTURE=amd64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
  *)
    echo_error "Unsupported architecture: $(uname -m)"
    exit 1
    ;;
esac
readonly ARCHITECTURE
curl -fL# "https://golang.org/dl/${VERSION}.linux-${ARCHITECTURE}.tar.gz" \
  | sudo tar xzf - -C /usr/local
