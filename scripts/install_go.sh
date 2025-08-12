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

echo_info 'Verify Go installation'
if /usr/local/go/bin/go version >/dev/null 2>&1; then
  echo_success "Verification passed: go is installed and accessible"
  if ! command -v go >/dev/null 2>&1; then
    echo_warn "Warning: /usr/local/go/bin is not in PATH. Add it to your shell profile."
  fi
else
  die "Error: Go installation failed"
fi
