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
else
  sudo -u "$(id -un)" docker pull ghcr.io/linuxserver/docker-compose:latest
  curl -L# https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh \
    | sudo tee /usr/local/bin/docker-compose >/dev/null
fi
sudo chmod +x /usr/local/bin/docker-compose
# LATEST=$(
#   curl -sSI https://github.com/docker/compose/releases/latest \
#     | tr -d '\r' \
#     | awk -F'/' '/^[Ll]ocation:/{print $NF}'
# )
# Bash completion for the latest version is not yet provided.
# Therefore, we use 1.29.2.
LATEST=1.29.2
readonly LATEST
curl -L# "https://raw.githubusercontent.com/docker/compose/${LATEST}/contrib/completion/bash/docker-compose" \
  | sudo tee /etc/bash_completion.d/docker-compose >/dev/null
