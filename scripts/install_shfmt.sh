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
esac
readonly ARCHITECTURE
curl -L# "https://github.com/mvdan/sh/releases/download/${LATEST}/shfmt_${LATEST}_linux_${ARCHITECTURE}" \
  | sudo tee /usr/local/bin/shfmt >/dev/null
sudo chmod 755 /usr/local/bin/shfmt
