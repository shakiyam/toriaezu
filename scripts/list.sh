#!/bin/bash
set -eu -o pipefail

show_version() {
  printf %-30s "$1"
  command -v "${3%% *}" > /dev/null 2>&1 && $3 2>&1 | awk "NR==$2" || echo -e "\033[36mnot found\033[0m"
}

echo 'Installed Software:'
show_version 'Docker'                  1 'docker -v'
show_version 'Docker Compose'          1 'docker-compose version'
show_version 'dockviz'                 1 'dockviz -v'
show_version 'Git'                     1 'git --version'
show_version 'Go Programming Language' 1 'go version'
show_version 'hadolint'                1 'hadolint -v'
show_version 'Micro'                   1 'micro -version'
show_version 'peco'                    1 'peco --version'
show_version 'Q'                       1 'q -v'
show_version 'ShellCheck'              2 'shellcheck -V'
show_version 'tmux'                    1 'tmux -V'