#!/bin/bash
set -eEu -o pipefail

# shellcheck source=scripts/colored_echo.sh
source "$(dirname "$0")/colored_echo.sh"

echo_info "Starting installation tests"
# shellcheck disable=SC1091
. /etc/os-release
echo_info "OS: $PRETTY_NAME"

echo_info "Running provision.sh all to install all tools..."
if ./provision.sh all; then
  echo_success "All tools installation completed"
else
  echo_error "provision.sh all failed"
  exit 1
fi

echo_info "Getting tool list and verifying installations..."
list_output=$(./scripts/list.sh 2>&1) || {
  echo_error "list.sh failed"
  exit 1
}

in_container=false
if [[ -f /.dockerenv ]] || [[ -n "${DOCKER_CONTAINER:-}" ]]; then
  in_container=true
  echo_info "Running in container - will skip Docker-dependent tools"
fi

skip_in_container=("OCI CLI")
installed_count=0
not_installed_count=0
skipped_count=0
not_installed_tools=()

while IFS= read -r line; do
  [[ "$line" == "Installed Software:" ]] && continue
  [[ -z "$line" ]] && continue
  tool_name=$(echo "$line" | cut -c1-30 | sed 's/[[:space:]]*$//')
  [[ -z "$tool_name" ]] && continue

  if [[ "$in_container" == true ]]; then
    for skip_tool in "${skip_in_container[@]}"; do
      if [[ "$tool_name" == "$skip_tool" ]]; then
        echo_info "⊘ $tool_name (skipped in container)"
        ((++skipped_count))
        continue 2
      fi
    done
  fi

  version_info=$(echo "$line" | cut -c31- | sed 's/^[[:space:]]*//')
  if [[ "$version_info" == *"not found"* ]]; then
    echo_warn "✗ $tool_name"
    not_installed_tools+=("$tool_name")
    ((++not_installed_count))
  elif [[ -n "$version_info" ]]; then
    echo_success "✓ $tool_name"
    ((++installed_count))
  fi
done <<<"$list_output"

if [[ "$in_container" == true && "$skipped_count" -gt 0 ]]; then
  echo_info "Installed: $installed_count, Not installed: $not_installed_count, Skipped: $skipped_count"
else
  echo_info "Installed: $installed_count, Not installed: $not_installed_count"
fi
echo
if ((not_installed_count == 0)); then
  echo_success "All testable tools installed successfully!"
else
  echo_error "Not installed: ${not_installed_tools[*]}"
  exit 1
fi
