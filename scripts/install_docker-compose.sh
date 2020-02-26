#!/bin/bash
set -eu -o pipefail

echo 'Install Docker Compose'
readonly LATEST=$(
  curl -sSI https://github.com/docker/compose/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^Location:/{print $NF}'
)
curl -L# "https://github.com/docker/compose/releases/download/${LATEST}/docker-compose-$(uname -s)-$(uname -m)" \
  | sudo tee /usr/local/bin/docker-compose >/dev/null
sudo chmod +x /usr/local/bin/docker-compose
curl -L# "https://raw.githubusercontent.com/docker/compose/${LATEST}/contrib/completion/bash/docker-compose" \
  | sudo tee /etc/bash_completion.d/docker-compose >/dev/null
