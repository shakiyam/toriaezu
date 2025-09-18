#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install fish'
case $OS_ID in
  ol)
    install_package --epel fish
    ;;
  ubuntu)
    install_package fish
    ;;
esac

echo_info 'Change login shell to Fish'
if ! command -v chsh &>/dev/null; then
  case $OS_ID in
    ol)
      install_package util-linux-user
      ;;
  esac
fi
sudo chsh -s /usr/bin/fish "$(id -u -n)"

echo_info 'Verify fish installation'
verify_installation fish
