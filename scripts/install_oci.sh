#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install OCI CLI'
DOCKER=$(command -v docker || command -v podman) || {
  echo_error "docker or podman not found"
  exit 1
}
curl -L# https://raw.githubusercontent.com/shakiyam/oci-cli-docker/main/oci \
  | sudo tee /usr/local/bin/oci >/dev/null
sudo chmod +x /usr/local/bin/oci
sudo -u "$(id -un)" "$DOCKER" pull ghcr.io/shakiyam/oci-cli
