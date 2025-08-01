#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

check_command() {
  command -v "$1" &>/dev/null || {
    echo_error "$1 not found"
    exit 1
  }
}

check_command fzf

echo_info 'Install enhancd'
LATEST=$(get_github_latest_release "babarot/enhancd")
readonly LATEST
mkdir -p "$HOME/.enhancd"
curl -L# https://github.com/babarot/enhancd/archive/refs/tags/"${LATEST}".tar.gz \
  | tar xzf - -C "$HOME/.enhancd" enhancd-"${LATEST#v}" --strip=1
