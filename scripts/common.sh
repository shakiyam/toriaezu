#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/colored_echo.sh"

# Get OS ID (ubuntu, ol, etc.)
get_os_id() {
  # shellcheck disable=SC1091
  . /etc/os-release
  echo "$ID"
}

# Get OS version
get_os_version() {
  # shellcheck disable=SC1091
  . /etc/os-release
  echo "$VERSION_ID"
}

# Get latest GitHub release tag
get_github_latest_release() {
  local repo="$1"
  curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"([^"]+)".*/\1/'
}

# Install package(s) using OS package manager
install_package() {
  local os_id
  os_id=$(get_os_id)

  case "$os_id" in
    ubuntu)
      sudo apt-get update
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
      ;;
    ol)
      sudo dnf install -y "$@"
      ;;
    *)
      echo_error "Error: Unsupported OS $os_id"
      return 1
      ;;
  esac
}
