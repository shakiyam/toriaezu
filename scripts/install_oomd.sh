#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install systemd-oomd'
case $OS_ID in
  ol)
    echo_warn 'systemd-oomd is supported only on Ubuntu, skipping'
    exit 0
    ;;
  ubuntu)
    install_package systemd-oomd
    ;;
esac

if is_container; then
  echo_warn 'Running in container environment, skipping systemctl setup'
  exit 0
fi

echo_info 'Setup systemd-oomd'
sudo systemctl enable systemd-oomd
# Restart because systemd-oomd started right after installation may not take its D-Bus name, which makes oomctl time out
sudo systemctl restart systemd-oomd

echo_info 'Verify systemd-oomd'
if oomctl >/dev/null; then
  echo_success 'Verification passed: systemd-oomd is running'
else
  die 'Error: systemd-oomd does not respond to oomctl'
fi
