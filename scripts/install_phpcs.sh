#!/bin/bash
set -eu -o pipefail

echo 'Install PHP_CodeSniffer'
readonly IMAGE_NAME='phpqa/phpcs'
if [[ $(command -v docker) ]]; then
  sudo docker pull $IMAGE_NAME
elif [[ $(command -v podman) ]]; then
  podman pull $IMAGE_NAME
else
  echo -e "\033[36mdocker or podman not found\033[0m"; exit 1;
fi
sudo cp "$(dirname "$0")/../bin/phpcs" /usr/local/bin/phpcs
sudo chmod +x /usr/local/bin/phpcs
