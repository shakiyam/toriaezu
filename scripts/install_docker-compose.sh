#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(. /etc/os-release; echo "$ID"); readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(. /etc/os-release; echo "$VERSION"); readonly OS_VERSION

echo 'Install Docker Compose'
if [[ ${OS_ID:-} == 'ol' && ${OS_VERSION%%.*} -eq 7 ]]; then
  LATEST=1.27.4
else
  LATEST=$(
    curl -sSI https://github.com/docker/compose/releases/latest \
      | tr -d '\r' \
      | awk -F'/' '/^[Ll]ocation:/{print $NF}'
  )
fi
readonly LATEST
curl -L# "https://github.com/docker/compose/releases/download/${LATEST}/docker-compose-$(uname -s)-$(uname -m)" \
  | sudo tee /usr/local/bin/docker-compose >/dev/null
sudo chmod +x /usr/local/bin/docker-compose
curl -L# "https://raw.githubusercontent.com/docker/compose/${LATEST}/contrib/completion/bash/docker-compose" \
  | sudo tee /etc/bash_completion.d/docker-compose >/dev/null
