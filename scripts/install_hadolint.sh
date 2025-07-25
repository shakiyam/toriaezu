#!/bin/bash
set -eu -o pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

echo 'Install hadolint'
case $(uname -m) in
  x86_64)
    ARCHITECTURE=x86_64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
esac
readonly ARCHITECTURE

LATEST=$(get_github_latest_release "hadolint/hadolint")
readonly LATEST
curl -L# "https://github.com/hadolint/hadolint/releases/download/${LATEST}/hadolint-Linux-${ARCHITECTURE}" \
  | sudo tee /usr/local/bin/hadolint >/dev/null
sudo chmod +x /usr/local/bin/hadolint
