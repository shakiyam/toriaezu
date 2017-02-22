#!/bin/bash
set -eu -o pipefail

# Install Docker Compose
docker_compose_latest=$(
  curl -sSI https://github.com/docker/compose/releases/latest |
    tr -d '\r' |
    awk -F'/' '/^Location:/{print $NF}'
)
curl -sSL "https://github.com/docker/compose/releases/download/${docker_compose_latest}/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
