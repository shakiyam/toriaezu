#!/bin/bash
set -eu -o pipefail

show_version() {
  printf %-30s "$1"
  command -v "${3%% *}" &>/dev/null && $3 |& awk "NR==$2" || echo -e "\033[36mnot found\033[0m"
}

echo 'Installed Software:'

show_version 'chezmoi'                   1 'chezmoi --version'
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
show_version 'fzf'                       1 'fzf --version'
show_version 'Git'                       1 'git --version'
show_version 'Go Programming Language'   1 'go version'
show_version 'hadolint'                  1 'hadolint -v'
show_version 'jq'                        1 'jq --version'
show_version 'kubectl'                   1 'kubectl version --client'
show_version 'OCI CLI'                   1 'oci -v'
show_version 'regctl'                    1 'regctl version'
show_version 'rigrep'                    1 'rg --version'
show_version 's3fs'                      1 's3fs --version'
show_version 'ShellCheck'                2 'shellcheck -V'
show_version 'shfmt'                     1 'shfmt -version'
show_version 'tmux'                      1 'tmux -V'
show_version 'UnZip'                     1 'unzip -v'
show_version 'Zip'                       2 'zip -v'
