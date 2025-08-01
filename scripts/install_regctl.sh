#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install regctl'
LATEST=$(get_github_latest_release "regclient/regclient")
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
curl -L# "https://github.com/regclient/regclient/releases/download/${LATEST}/regctl-linux-${ARCHITECTURE}" \
  | sudo tee /usr/local/bin/regctl >/dev/null
sudo chmod 755 /usr/local/bin/regctl
