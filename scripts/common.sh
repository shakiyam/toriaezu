#!/bin/bash
set -eEu -o pipefail

# Prevent unbound variable error: mise activate bash references PROMPT_COMMAND under set -u
PROMPT_COMMAND="${PROMPT_COMMAND:-}"

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/colored_echo.sh"

die() {
  if [[ $# -eq 0 ]]; then
    echo_error "Error: No message specified for die"
    exit 1
  fi

  local -r message="$1"
  local -r exit_code="${2:-1}"
  echo_error "$message"
  exit "$exit_code"
}

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
  if [[ $# -eq 0 ]]; then
    die "Error: No repository specified for get_github_latest_release"
  fi

  local -r repo="$1"
  curl -fsSL --proto '=https' --tlsv1.2 "https://api.github.com/repos/${repo}/releases/latest" 2>/dev/null \
    | grep '"tag_name":' \
    | sed -E 's/.*"([^"]+)".*/\1/' || die "Error: Failed to fetch latest release for ${repo}"
}

should_update_package_index() {
  local -r timestamp_file="/tmp/.toriaezu_apt_update_timestamp"
  local -r update_interval=3600
  local -r sources_list="/etc/apt/sources.list"
  local -r sources_dir="/etc/apt/sources.list.d"
  local -r keyrings_dir="/etc/apt/keyrings"

  if [[ ! -f "$timestamp_file" ]]; then
    return 0
  fi
  if [[ -d "$sources_dir" ]] && find "$sources_dir" -newer "$timestamp_file" -print -quit 2>/dev/null | grep -q .; then
    echo_info "Repository configuration changed"
    return 0
  fi
  if [[ -d "$keyrings_dir" ]] && find "$keyrings_dir" -newer "$timestamp_file" -print -quit 2>/dev/null | grep -q .; then
    echo_info "GPG keyrings updated"
    return 0
  fi
  if [[ -f "$sources_list" && "$sources_list" -nt "$timestamp_file" ]]; then
    echo_info "Sources list modified"
    return 0
  fi
  if [[ $(($(date +%s) - $(stat -c %Y "$timestamp_file" 2>/dev/null || echo 0))) -gt $update_interval ]]; then
    echo_info "Package index update interval expired"
    return 0
  fi
  return 1
}

mark_package_index_updated() {
  touch /tmp/.toriaezu_apt_update_timestamp
}

install_package() {
  local -r os_id=$(get_os_id)
  local use_epel=false
  local packages=()

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

  if [[ ${#packages[@]} -eq 0 ]]; then
    die "Error: No packages specified for install_package"
  fi

  case "$os_id" in
    ubuntu)
      if should_update_package_index; then
        echo_info "Updating package index..."
        sudo apt-get update
        mark_package_index_updated
      else
        echo_info "Package index is recent (less than 1 hour old)"
      fi
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}"
      ;;
    ol)
      if [[ "$use_epel" == true ]]; then
        local -r os_version=$(get_os_version)
        local epel_repo=""

        case "$os_version" in
          8*)
            epel_repo="ol8_developer_EPEL"
            ;;
          9*)
            epel_repo="ol9_developer_EPEL"
            ;;
          *)
            die "Error: Unknown Oracle Linux version: $os_version"
            ;;
        esac

        sudo dnf -y --enablerepo="$epel_repo" install "${packages[@]}"
      else
        sudo dnf install -y "${packages[@]}"
      fi
      ;;
    *)
      die "Error: Unsupported OS: $os_id"
      ;;
  esac
}

verify_installation() {
  if [[ $# -eq 0 ]]; then
    die "Error: No command specified for verify_installation"
  fi

  local -r command="$1"
  if command -v "$command" &>/dev/null; then
    echo_success "Verification passed: $command is installed and accessible"
  else
    die "Error: Command $command not found in PATH"
  fi
}
