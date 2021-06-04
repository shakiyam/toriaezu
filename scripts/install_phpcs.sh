#!/bin/bash
set -eu -o pipefail

echo 'Install PHP_CodeSniffer'
readonly IMAGE_NAME='shakiyam/phpcs'
if [[ $(command -v docker) ]]; then
  sudo docker pull $IMAGE_NAME
elif [[ $(command -v podman) ]]; then
  podman pull $IMAGE_NAME
else
  echo -e "\033[36mdocker or podman not found\033[0m"
  exit 1
fi
curl -L# https://raw.githubusercontent.com/shakiyam/phpcs-docker/main/phpcs \
  | sudo tee /usr/local/bin/phpcs >/dev/null
sudo chmod +x /usr/local/bin/phpcs
