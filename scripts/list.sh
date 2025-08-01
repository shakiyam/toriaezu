#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

show_version() {
  printf %-30s "$1"
  if command -v "${3%% *}" &>/dev/null; then
    $3 |& awk "NR==$2"
  else
    echo_warn "not found"
  fi
}

echo_info 'Installed Software:'

show_version 'bat'                       1 'bat --version'
show_version 'chezmoi'                   1 'chezmoi --version'
show_version 'Claude Code'               1 'claude --version'
show_version 'csvq'                      1 'csvq -v'
if command -v docker &>/dev/null; then
  show_version 'Docker'                  1 'docker -v'
else
  show_version 'Docker'                  1 'podman -v'
fi
if command -v docker-compose &>/dev/null; then
  show_version 'Docker Compose'          1 'docker-compose -v'
else
  show_version 'Docker Compose'          1 'docker compose version'
fi
show_version 'dockviz'                   1 'dockviz -v'
show_version 'eza'                       2 'eza --version'
show_version 'fzf'                       1 'fzf --version'
show_version 'fish'                      1 'fish --version'
show_version 'Git'                       1 'git --version'
show_version 'Go Programming Language'   1 'go version'
show_version 'hadolint'                  1 'hadolint -v'
show_version 'jq'                        1 'jq --version'
show_version 'kubectl'                   1 'kubectl version --client'
show_version 'Node.js'                   1 'node -v'
show_version 'OCI CLI'                   1 'oci -v'
show_version 'regctl'                    1 'regctl version'
show_version 'ripgrep'                   1 'rg --version'
show_version 's3fs'                      1 's3fs --version'
show_version 'ShellCheck'                2 'shellcheck -V'
show_version 'shfmt'                     1 'shfmt -version'
show_version 'tmux'                      1 'tmux -V'
show_version 'UnZip'                     1 'unzip -v'
show_version 'XZ Utils'                  1 'xz --version'
show_version 'Zip'                       2 'zip -v'
