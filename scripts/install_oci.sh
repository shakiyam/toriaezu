#!/bin/bash
set -eu -o pipefail

echo 'Install OCI CLI'
DOCKER=$(command -v docker || command -v podman) || {
  echo -e "\033[36mdocker or podman not found\033[0m"
  exit 1
}
curl -L# https://raw.githubusercontent.com/shakiyam/oci-cli-docker/master/oci \
  | sudo tee /usr/local/bin/oci >/dev/null
sudo chmod +x /usr/local/bin/oci
"$DOCKER" pull docker.io/shakiyam/oci-cli
