#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install Go Programming Language'
VERSION=$(curl -fsSL https://go.dev/VERSION?m=text | head -n 1) || die "Error: Failed to fetch Go version"
readonly VERSION
case $(uname -m) in
  x86_64)
    ARCHITECTURE=amd64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
  *)
    die "Error: Unsupported architecture: $(uname -m)"
    ;;
esac
readonly ARCHITECTURE
curl -fL# "https://golang.org/dl/${VERSION}.linux-${ARCHITECTURE}.tar.gz" \
  | sudo tar xzf - -C /usr/local
