#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install shfmt'
LATEST=$(get_github_latest_release "mvdan/sh")
readonly LATEST
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
curl -fL# "https://github.com/mvdan/sh/releases/download/${LATEST}/shfmt_${LATEST}_linux_${ARCHITECTURE}" \
  | sudo install -m 755 /dev/stdin /usr/local/bin/shfmt

echo_info 'Verify shfmt installation'
verify_command shfmt
