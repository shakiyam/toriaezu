#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

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
    die "Error: Unsupported architecture: $(uname -m)"
    ;;
esac
readonly ARCHITECTURE
curl -fL# --proto '=https' --tlsv1.2 "https://github.com/regclient/regclient/releases/download/${LATEST}/regctl-linux-${ARCHITECTURE}" \
  | sudo install -m 755 /dev/stdin /usr/local/bin/regctl

echo_info 'Verify regctl installation'
verify_installation regctl
