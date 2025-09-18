#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo_info 'Install chezmoi'
LATEST=$(get_github_latest_release "twpayne/chezmoi")
readonly LATEST
case $(uname -m) in
  x86_64)
    ARCHITECTURE=amd64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
  *)
    die "Error: Unsupported architecture: $(uname -m)"
    ;;
esac
readonly ARCHITECTURE

# Use musl version for Oracle Linux 8 x86_64 to avoid GLIBC compatibility issues
OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION
MUSL_SUFFIX=""
if [[ "$OS_ID" == "ol" && "${OS_VERSION%%.*}" == "8" && "$ARCHITECTURE" == "amd64" ]]; then
  echo_info 'Using musl static binary for GLIBC compatibility'
  MUSL_SUFFIX="-musl"
fi
readonly MUSL_SUFFIX

TEMP_DIR=$(mktemp -d)
readonly TEMP_DIR
trap 'sudo rm -rf "$TEMP_DIR"' EXIT
curl -fL# "https://github.com/twpayne/chezmoi/releases/download/${LATEST}/chezmoi_${LATEST#v}_linux${MUSL_SUFFIX}_${ARCHITECTURE}.tar.gz" \
  | sudo tar xzf - -C "$TEMP_DIR"
sudo install -m 755 "$TEMP_DIR"/chezmoi /usr/local/bin/
sudo install -m 644 "$TEMP_DIR"/completions/chezmoi-completion.bash /usr/share/bash-completion/completions/chezmoi
sudo mkdir -p /usr/share/fish/vendor_completions.d
sudo install -m 644 "$TEMP_DIR"/completions/chezmoi.fish /usr/share/fish/vendor_completions.d/
echo_info 'Verify chezmoi installation'
verify_installation chezmoi

echo_info 'Initialize and apply dotfiles'
chezmoi init https://github.com/shakiyam/dotfiles
chezmoi apply
