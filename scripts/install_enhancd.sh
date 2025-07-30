#!/bin/bash
set -eu -o pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

command_exists() {
  command -v "$1" &>/dev/null
}

command_exists /usr/local/bin/cho || command_exists "$HOME"/go/bin/cho || command_exists fzf || {
  echo "ERROR: To install enhancd, you will need cho or fzf or peco."
  exit 1
}

echo 'Install enhancd'
LATEST=$(get_github_latest_release "babarot/enhancd")
readonly LATEST
mkdir -p "$HOME/.enhancd"
curl -L# https://github.com/babarot/enhancd/archive/refs/tags/"${LATEST}".tar.gz \
  | tar xzf - -C "$HOME/.enhancd" enhancd-"${LATEST#v}" --strip=1
