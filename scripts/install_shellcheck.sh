#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install ShellCheck'
case $OS_ID in
  ol)
    curl -L# https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz \
      | xz -d -c \
      | sudo tar xf - -C /usr/local/bin/ --strip=1 shellcheck-stable/shellcheck
    sudo chown root:root /usr/local/bin/shellcheck
    sudo chmod +x /usr/local/bin/shellcheck
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install shellcheck
    ;;
esac
