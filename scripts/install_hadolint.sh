#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install hadolint'
case $(uname -m) in
  x86_64)
    ARCHITECTURE=x86_64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
  *)
    die "Error: Unsupported architecture: $(uname -m)"
    ;;
esac
readonly ARCHITECTURE

LATEST=$(get_github_latest_release "hadolint/hadolint")
readonly LATEST
curl -fL# "https://github.com/hadolint/hadolint/releases/download/${LATEST}/hadolint-Linux-${ARCHITECTURE}" \
  | sudo install -m 755 /dev/stdin /usr/local/bin/hadolint
