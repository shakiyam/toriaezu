#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID

echo 'Install Docker Compose'
LATEST=$(
  curl -sSI https://github.com/docker/compose/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
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
