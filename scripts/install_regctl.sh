#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install regctl'
LATEST=$(get_github_latest_release "regclient/regclient")
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
curl -fL# "https://github.com/regclient/regclient/releases/download/${LATEST}/regctl-linux-${ARCHITECTURE}" \
  | sudo install -m 755 /dev/stdin /usr/local/bin/regctl
