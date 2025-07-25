#!/bin/bash
set -eu -o pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

echo 'Install Bash Line Editor'
mkdir -p "$HOME/.blesh"
LATEST=$(get_github_latest_release "akinomyoga/ble.sh")
readonly LATEST
curl -L# "https://github.com/akinomyoga/ble.sh/releases/download/${LATEST}/ble-${LATEST#v}.tar.xz" \
  | tar xJf - -C "$HOME/.blesh" --strip=1
