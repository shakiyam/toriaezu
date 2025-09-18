#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo_info 'Install hadolint'
case $(uname -m) in
  x86_64)
    ARCHITECTURE=x86_64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
  *)
    die "Error: Unsupported architecture: $(uname -m)"
    ;;
esac
readonly ARCHITECTURE

LATEST=$(get_github_latest_release "hadolint/hadolint")
readonly LATEST
curl -fL# "https://github.com/hadolint/hadolint/releases/download/${LATEST}/hadolint-Linux-${ARCHITECTURE}" \
  | sudo install -m 755 /dev/stdin /usr/local/bin/hadolint

if [[ "$OS_ID" == "ol" && "${OS_VERSION%%.*}" == "9" ]]; then
  echo_info 'Check if hadolint needs decompression for Oracle Linux 9 SELinux compatibility'
  if ! command -v upx &>/dev/null; then
    install_package --epel upx
  fi
  # Try to decompress, but ignore error if already decompressed or not packed
  if sudo upx -t /usr/local/bin/hadolint &>/dev/null; then
    echo_info 'Decompress hadolint'
    sudo upx -d /usr/local/bin/hadolint
  else
    echo_info 'hadolint is not UPX compressed, skipping decompression'
  fi
fi

echo_info 'Verify hadolint installation'
verify_installation hadolint
