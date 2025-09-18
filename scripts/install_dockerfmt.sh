#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install dockerfmt'
LATEST=$(get_github_latest_release "reteps/dockerfmt")
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
curl -fL# "https://github.com/reteps/dockerfmt/releases/download/${LATEST}/dockerfmt-${LATEST}-linux-${ARCHITECTURE}.tar.gz" \
  | tar xzf - -O dockerfmt \
  | sudo install -m 755 /dev/stdin /usr/local/bin/dockerfmt

echo_info 'Verify dockerfmt installation'
verify_installation dockerfmt
