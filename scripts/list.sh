#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

show_version() {
  local -r display_name="$1"
  local -r line_number="$2"
  local -r command="$3"

  printf %-30s "$display_name"
  local output
  if output=$(eval "$command" 2>&1); then
    echo "$output" | awk "NR==$line_number"
  else
    echo_warn "not found"
  fi
}

echo_info 'Installed Software:'

show_version "bat" 1 "bat --version"
show_version "chezmoi" 1 "chezmoi --version"
show_version "Claude Code" 1 "claude --version"
show_version "csvq" 1 "csvq -v"
show_version "Docker" 1 "(command -v docker &>/dev/null && docker -v) || (command -v podman &>/dev/null && podman -v)"
show_version "Docker Compose" 1 "(command -v docker-compose &>/dev/null && docker-compose -v) || (command -v docker &>/dev/null && docker compose version)"
show_version "Docker Tools" 1 "command -v dcls &>/dev/null && command -v dclogs &>/dev/null && echo 'dcls, dclogs installed'"
show_version "dockviz" 1 "dockviz -v"
show_version "enhancd" 1 "command -v fish &>/dev/null && fish -c 'fisher list' | grep -q enhancd && echo 'installed'"
show_version "eza" 2 "eza --version"
show_version "Fisher" 1 "fish -c 'functions -q fisher' &>/dev/null && fish -c 'fisher -v'"
show_version "fish" 1 "fish --version"
show_version "fzf" 1 "fzf --version"
show_version "Git" 1 "git --version"
show_version "Go Programming Language" 1 "go version"
show_version "hadolint" 1 "hadolint -v"
show_version "jq" 1 "jq --version"
show_version "kubectl" 1 "kubectl version --client"
show_version "NFS" 1 "mount.nfs -V"
show_version "Node.js" 1 "node -v"
show_version "OCI CLI" 1 "oci -v"
show_version "regctl" 1 "regctl version"
show_version "ripgrep" 1 "rg --version"
show_version "s3fs" 1 "s3fs --version"
show_version "ShellCheck" 2 "shellcheck -V"
show_version "shfmt" 1 "shfmt -version"
show_version "tmux" 1 "tmux -V"
show_version "UnZip" 1 "unzip -v"
show_version "XZ Utils" 1 "xz --version"
show_version "Zip" 2 "zip -v"
