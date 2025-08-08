#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/colored_echo.sh"

get_os_id() {
  # shellcheck disable=SC1091
  . /etc/os-release
  echo "$ID"
}

get_os_version() {
  # shellcheck disable=SC1091
  . /etc/os-release
  echo "$VERSION_ID"
}

get_github_latest_release() {
  local repo="$1"
  curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" 2>/dev/null \
    | grep '"tag_name":' \
    | sed -E 's/.*"([^"]+)".*/\1/' || {
    echo_error "Failed to fetch latest release for ${repo}"
    return 1
  }
}

install_package() {
  local -r _OS_ID=${OS_ID:-$(get_os_id)}
  local use_epel=false
  local packages=()

  # Parse arguments for --epel flag
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --epel)
        use_epel=true
        shift
        ;;
      *)
        packages+=("$1")
        shift
        ;;
    esac
  done

  # Check if packages array is empty
  if [[ ${#packages[@]} -eq 0 ]]; then
    echo_error "Error: No packages specified for installation"
    return 1
  fi

  case "$_OS_ID" in
    ubuntu)
      sudo apt-get update
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}"
      ;;
    ol)
      if [[ "$use_epel" == true ]]; then
        local -r _OS_VERSION=${OS_VERSION:-$(get_os_version)}
        local epel_repo=""

        case "$_OS_VERSION" in
          8*)
            epel_repo="ol8_developer_EPEL"
            ;;
          9*)
            epel_repo="ol9_developer_EPEL"
            ;;
          *)
            echo_error "Error: Unknown Oracle Linux version: $_OS_VERSION"
            return 1
            ;;
        esac

        sudo dnf -y --enablerepo="$epel_repo" install "${packages[@]}"
      else
        sudo dnf install -y "${packages[@]}"
      fi
      ;;
    *)
      echo_error "Error: Unsupported OS $_OS_ID"
      return 1
      ;;
  esac
}
