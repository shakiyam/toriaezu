#!/bin/bash
set -eu -o pipefail

echo 'Install OCI CLI'
readonly IMAGE_NAME='shakiyam/oci-cli'
[[ $(command -v docker) ]] || { echo -e "\033[36mdocker not found\033[0m"; exit 1; }
sudo docker pull $IMAGE_NAME
curl -L# https://raw.githubusercontent.com/shakiyam/oci-cli-docker/master/oci \
  | sudo tee /usr/local/bin/oci >/dev/null
sudo chmod +x /usr/local/bin/oci
