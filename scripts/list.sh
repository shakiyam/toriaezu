#!/bin/bash
set -eu -o pipefail

show_version() {
  printf %-30s "$1"
  command -v "${3%% *}" > /dev/null 2>&1 && $3 2>&1 | awk "NR==$2" || echo -e "\033[36mnot found\033[0m"
}

echo 'Installed Software:'

show_version 'Checkstyle'                1 'checkstyle -V'
show_version 'csvq'                      1 'csvq -v'
show_version 'Docker'                    1 'docker -v'
show_version 'Docker Compose'            1 'docker-compose version'
show_version 'dockviz'                   1 'dockviz -v'
show_version 'fzy'                       1 'fzy -v'
show_version 'Git'                       1 'git --version'
show_version 'Go Programming Language'   1 'go version'
show_version 'hadolint'                  1 'hadolint -v'
show_version 'Jobber'                    1 'jobber -v'
show_version 'jq'                        1 'jq --version'
show_version 'Node.js'                   1 'node -v'
show_version 'OCI CLI'                   1 'oci -v'
show_version 'OpenJDK Development Kit'   1 'java -version'
show_version 'peco'                      1 'peco --version'
show_version 'PHP_CodeSniffer'           1 'phpcs --version'
show_version 'Python3'                   1 'python3 -V'
show_version 'Q'                         1 'q -v'
show_version 'RuboCop'                   1 'rubocop -v'
show_version 'Ruby'                      1 'ruby --version'
show_version 's3fs'                      1 's3fs --version'
show_version 'ShellCheck'                2 'shellcheck -V'
show_version 'SVFS'                      3 'svfs version'
show_version 'The Platinum Searcher'     1 'pt --version'
show_version 'tmux'                      1 'tmux -V'
show_version 'UnZip'                     1 'unzip -v'
show_version 'Wercker CLI'               1 'wercker -v'
