#!/bin/bash
set -eu -o pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

echo 'Install cho'
case $(uname -m) in
  x86_64)
    ARCHITECTURE=amd64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
esac
readonly ARCHITECTURE
LATEST=$(get_github_latest_release "mattn/cho")
readonly LATEST
curl -L# "https://github.com/mattn/cho/releases/download/${LATEST}/cho_${LATEST}_linux_${ARCHITECTURE}.tar.gz" \
  | sudo tar xzf - -C /usr/local/bin/ --strip=1 "cho_${LATEST}_linux_${ARCHITECTURE}/cho"
