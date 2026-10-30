#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "$0")/common.sh"

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

echo_info "Re-running targets to verify idempotency..."
if make install_chezmoi install_docker install_oci; then
  echo_success "Re-run completed"
else
  echo_error "Error: Re-run failed"
  exit 1
fi

if [[ "$ID" == "ol" ]]; then
  echo_info "Verifying Podman network backend configuration..."
  if rpm -q netavark aardvark-dns && grep -qs '^network_backend = "netavark"$' /etc/containers/containers.conf.d/*.conf; then
    echo_success "Podman is configured to use netavark"
  else
    echo_error "Error: Podman is not configured to use netavark"
    exit 1
  fi
fi

if [[ "$ID" == "ol" && "${VERSION_ID%%.*}" == 9 ]]; then
  echo_info "Verifying cgroup controller delegation..."
  if grep -qs '^Delegate=cpu cpuset io memory pids$' /etc/systemd/system/user@.service.d/delegate.conf; then
    echo_success "cgroup controllers are delegated to users"
  else
    echo_error "Error: cgroup controllers are not delegated to users"
    exit 1
  fi
fi

echo_info "Verifying herdr reinstalls its Claude Code integration on install..."
eval "$(mise activate bash)"
mkdir -p "$HOME/.claude"
# Remove the hook installed by install_herdr.sh so that only the postinstall can restore it
rm -f "$HOME/.claude/hooks/herdr-agent-state.sh"
# Capture output before grep -q, which would make the writer fail with SIGPIPE under pipefail
if mise install -f herdr \
  && herdr_status=$(herdr integration status) \
  && grep -q '^claude: current ' <<<"$herdr_status"; then
  echo_success "herdr reinstalls its Claude Code integration"
else
  echo_error "Error: herdr does not reinstall its Claude Code integration"
  exit 1
fi

echo_info "Getting tool list and verifying installations..."
list_output=$(./scripts/list.sh 2>&1) || {
  echo_error "Error: list.sh failed"
  exit 1
}

declare -A skip_reasons=()
if is_container; then
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
  if [[ -z "$version_info" || "$version_info" == "not found" ]]; then
    echo_warn "✗ $tool_name"
    not_installed_tools+=("$tool_name")
    ((++not_installed_count))
  else
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
