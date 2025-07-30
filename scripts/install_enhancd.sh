#!/bin/bash
set -eu -o pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

check_command() {
  command -v "$1" &>/dev/null || {
    echo -e "\033[36m$1 not found\033[0m"
    exit 1
  }
}

check_command fzf

echo 'Install enhancd'
LATEST=$(get_github_latest_release "babarot/enhancd")
readonly LATEST
mkdir -p "$HOME/.enhancd"
curl -L# https://github.com/babarot/enhancd/archive/refs/tags/"${LATEST}".tar.gz \
  | tar xzf - -C "$HOME/.enhancd" enhancd-"${LATEST#v}" --strip=1
