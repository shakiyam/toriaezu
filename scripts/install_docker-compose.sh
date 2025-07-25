#!/bin/bash
set -eu -o pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"
OS_ID=$(get_os_id)
readonly OS_ID

echo 'Install Docker Compose'
LATEST=$(get_github_latest_release "docker/compose")
readonly LATEST
case $OS_ID in
  ol)
    curl -L# "https://github.com/docker/compose/releases/download/${LATEST}/docker-compose-linux-$(uname -m)" \
      | sudo tee /usr/local/bin/docker-compose >/dev/null
    sudo chmod +x /usr/local/bin/docker-compose
    ;;
  ubuntu)
    sudo mkdir -p /usr/local/lib/docker/cli-plugins
    curl -L# "https://github.com/docker/compose/releases/download/${LATEST}/docker-compose-linux-$(uname -m)" \
      | sudo tee /usr/local/lib/docker/cli-plugins/docker-compose >/dev/null
    sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    ;;
esac
