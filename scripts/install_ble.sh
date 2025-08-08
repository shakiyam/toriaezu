#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install Bash Line Editor'
mkdir -p "$HOME/.blesh"
LATEST=$(get_github_latest_release "akinomyoga/ble.sh")
readonly LATEST
curl -fL# "https://github.com/akinomyoga/ble.sh/releases/download/${LATEST}/ble-${LATEST#v}.tar.xz" \
  | tar xJf - -C "$HOME/.blesh" --strip=1
