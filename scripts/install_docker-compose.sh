#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"
OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install Docker Compose'
if ! command -v mise &>/dev/null; then
  die "Error: Command not found: mise. Run 'make install_mise'."
fi

echo_info 'Cleanup legacy Docker Compose installations'
case $OS_ID in
  ol)
    sudo rm -f /usr/local/bin/docker-compose
    ;;
  ubuntu)
    sudo rm -f /usr/local/lib/docker/cli-plugins/docker-compose
    ;;
esac

eval "$(mise activate bash)"
mise use --global aqua:docker/compose@latest
eval "$(mise activate bash)"

# The aqua package ships the binary as `docker-cli-plugin-docker-compose`,
# so mise does not auto-create a `docker-compose` shim. Link it manually via
# mise's `latest` alias so future `mise upgrade` is picked up transparently.
COMPOSE_BIN="$(dirname "$(mise where aqua:docker/compose)")/latest/docker-cli-plugin-docker-compose"
readonly COMPOSE_BIN

case $OS_ID in
  ol)
    echo_info 'Link docker-compose into ~/.local/bin'
    mkdir -p "${HOME}/.local/bin"
    ln -sf "$COMPOSE_BIN" "${HOME}/.local/bin/docker-compose"
    ;;
  ubuntu)
    echo_info 'Register Docker Compose as Docker CLI plugin'
    mkdir -p "${HOME}/.docker/cli-plugins"
    ln -sf "$COMPOSE_BIN" "${HOME}/.docker/cli-plugins/docker-compose"
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
