#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install dockerfmt'
LATEST=$(get_github_latest_release "jessfraz/dockfmt")
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
curl -fL# "https://github.com/jessfraz/dockfmt/releases/download/${LATEST}/dockfmt-linux-${ARCHITECTURE}" \
  | sudo install -m 755 /dev/stdin /usr/local/bin/dockfmt

echo_info 'Verify dockerfmt installation'
verify_installation dockfmt
