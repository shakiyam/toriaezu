#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"
OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install Docker Compose'
LATEST=$(get_github_latest_release "docker/compose")
readonly LATEST
case $OS_ID in
  ol)
    curl -fL# "https://github.com/docker/compose/releases/download/${LATEST}/docker-compose-linux-$(uname -m)" \
      | sudo install -m 755 /dev/stdin /usr/local/bin/docker-compose
    ;;
  ubuntu)
    sudo mkdir -p /usr/local/lib/docker/cli-plugins
    curl -fL# "https://github.com/docker/compose/releases/download/${LATEST}/docker-compose-linux-$(uname -m)" \
      | sudo install -m 755 /dev/stdin /usr/local/lib/docker/cli-plugins/docker-compose
    ;;
esac

echo_info 'Verify Docker Compose installation'
case $OS_ID in
  ol)
    verify_installation docker-compose
    ;;
  ubuntu)
    if docker compose version &>/dev/null; then
      echo_success "Verification passed: docker compose is installed and accessible"
    else
      die "Error: docker compose not found or not working"
    fi
    ;;
esac
