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
  echo_error "Error: provision.sh all failed"
  exit 1
fi

echo_info "Getting tool list and verifying installations..."
list_output=$(./scripts/list.sh 2>&1) || {
  echo_error "Error: list.sh failed"
  exit 1
}

declare -A skip_reasons=()
if [[ -f /.dockerenv ]] || [[ -n "${DOCKER_CONTAINER:-}" ]]; then
  echo_info "Running in container - will skip Docker-dependent tools"
  skip_reasons["OCI CLI"]="requires Docker/Podman, not available in container"
fi
if [[ "$ID" == "ol" && "${VERSION_ID%%.*}" == "8" ]]; then
  skip_reasons["zizmor"]="requires GLIBC 2.34 or later, not available on Oracle Linux 8"
fi

installed_count=0
not_installed_count=0
skipped_count=0
not_installed_tools=()

while IFS= read -r line; do
  [[ "$line" == "Installed Software:" ]] && continue
  [[ -z "$line" ]] && continue
  tool_name=$(echo "$line" | cut -c1-30 | sed 's/[[:space:]]*$//')
  [[ -z "$tool_name" ]] && continue

  if [[ -n "${skip_reasons[$tool_name]:-}" ]]; then
    echo_info "⊘ $tool_name (skipped: ${skip_reasons[$tool_name]})"
    ((++skipped_count))
    continue
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

if ((skipped_count > 0)); then
  echo_info "Installed: $installed_count, Not installed: $not_installed_count, Skipped: $skipped_count"
else
  echo_info "Installed: $installed_count, Not installed: $not_installed_count"
fi
echo
if ((not_installed_count == 0)); then
  echo_success "All testable tools installed successfully!"
else
  echo_error "Error: Not installed: ${not_installed_tools[*]}"
  exit 1
fi
