#!/bin/bash
set -eu -o pipefail

echo 'Install Docker Compose'
sudo -u "$(id -un)" docker pull ghcr.io/linuxserver/docker-compose:latest
curl -L# https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh \
  | sudo tee /usr/local/bin/docker-compose >/dev/null
sudo chmod +x /usr/local/bin/docker-compose
LATEST=$(
  curl -sSI https://github.com/docker/compose/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
curl -L# "https://raw.githubusercontent.com/docker/compose/${LATEST}/contrib/completion/bash/docker-compose" \
  | sudo tee /etc/bash_completion.d/docker-compose >/dev/null
