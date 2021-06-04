#!/bin/bash
set -eu -o pipefail

echo 'Install RuboCop'
readonly IMAGE_NAME='shakiyam/rubocop'
if [[ $(command -v docker) ]]; then
  sudo docker pull $IMAGE_NAME
elif [[ $(command -v podman) ]]; then
  podman pull $IMAGE_NAME
else
  echo -e "\033[36mdocker or podman not found\033[0m"
  exit 1
fi
curl -L# https://raw.githubusercontent.com/shakiyam/rubocop-docker/master/rubocop \
  | sudo tee /usr/local/bin/rubocop >/dev/null
sudo chmod +x /usr/local/bin/rubocop
