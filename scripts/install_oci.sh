#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Skip OCI CLI installation in container environments
if [[ -f /.dockerenv ]] || grep -q 'docker\|lxc' /proc/1/cgroup 2>/dev/null; then
  echo_warn 'Running in container environment, skipping OCI CLI installation (requires Docker/Podman)'
  exit 0
fi

echo_info 'Install OCI CLI'
DOCKER=$(command -v docker || command -v podman) || {
  echo_error "docker or podman not found"
  exit 1
}
curl -fL# https://raw.githubusercontent.com/shakiyam/oci-cli-docker/main/oci \
  | sudo install -m 755 /dev/stdin /usr/local/bin/oci
sudo -u "$(id -un)" "$DOCKER" pull ghcr.io/shakiyam/oci-cli
