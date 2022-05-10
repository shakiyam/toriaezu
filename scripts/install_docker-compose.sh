#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(
  . /etc/os-release
  echo "$VERSION"
)
readonly OS_VERSION

echo 'Install Docker Compose'
if [[ ${OS_ID:-} == 'ol' && ${OS_VERSION%%.*} -eq 8 ]]; then
  podman pull ghcr.io/linuxserver/docker-compose:latest
  sudo cp "$(dirname "$0")/../bin/docker-compose" /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  # Docker Compose 1.29.2 is the latest Docker Compose v1
  readonly LATEST=1.29.2
  curl -L# "https://raw.githubusercontent.com/docker/compose/${LATEST}/contrib/completion/bash/docker-compose" \
    | sudo tee /etc/bash_completion.d/docker-compose >/dev/null
else
  sudo mkdir -p /usr/local/lib/docker/cli-plugins
  curl -L# "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" \
    | sudo tee /usr/local/lib/docker/cli-plugins/docker-compose >/dev/null
  sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
fi
