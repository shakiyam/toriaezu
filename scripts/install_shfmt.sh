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
    echo_error "Unsupported architecture: $(uname -m)"
    exit 1
    ;;
esac
readonly ARCHITECTURE
curl -fL# "https://github.com/mvdan/sh/releases/download/${LATEST}/shfmt_${LATEST}_linux_${ARCHITECTURE}" \
  | sudo install -m 755 /dev/stdin /usr/local/bin/shfmt
