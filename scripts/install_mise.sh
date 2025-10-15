#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo_info 'Install mise'
if [[ "$OS_ID" == "ol" && "${OS_VERSION%%.*}" == "8" ]]; then
  echo_info 'Using musl static binary for GLIBC compatibility on Oracle Linux 8'
  LATEST=$(get_github_latest_release "jdx/mise")
  readonly LATEST
  case $(uname -m) in
    x86_64)
      ARCHITECTURE="x64"
      ;;
    aarch64)
      ARCHITECTURE="arm64"
      ;;
    *)
      die "Error: Unsupported architecture: $(uname -m)"
      ;;
  esac
  readonly ARCHITECTURE

  TEMP_DIR=$(mktemp -d)
  readonly TEMP_DIR
  trap 'sudo rm -rf "$TEMP_DIR"' EXIT
  curl -fL# --proto '=https' --tlsv1.2 "https://github.com/jdx/mise/releases/download/${LATEST}/mise-${LATEST}-linux-${ARCHITECTURE}-musl" \
    -o "$TEMP_DIR/mise"
  sudo install -m 755 "$TEMP_DIR/mise" /usr/local/bin/
else
  curl -fsSL --proto '=https' --tlsv1.2 https://mise.jdx.dev/install.sh | sh
fi
eval "$(mise activate bash)"

echo_info 'Verify mise installation'
verify_installation mise
