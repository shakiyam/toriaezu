#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install Docker Compose'
docker_compose_latest=$(
  curl -sSI https://github.com/docker/compose/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^Location:/{print $NF}'
)
if [[ "$OS_ID" = 'ol' && "${OS_VERSION%%.*}" = '6' ]]; then
  docker_compose_latest=1.9.0
fi
curl -L# "https://github.com/docker/compose/releases/download/${docker_compose_latest}/docker-compose-$(uname -s)-$(uname -m)" \
  | sudo tee /usr/local/bin/docker-compose >/dev/null
sudo chmod +x /usr/local/bin/docker-compose
curl -L# "https://raw.githubusercontent.com/docker/compose/${docker_compose_latest}/contrib/completion/bash/docker-compose" \
  | sudo tee /etc/bash_completion.d/docker-compose >/dev/null
