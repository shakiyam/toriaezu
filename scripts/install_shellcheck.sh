#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID

echo 'Install ShellCheck'
case $OS_ID in
  ol)
    curl -L# "https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.$(uname -m).tar.xz" \
      | sudo tar xJf - -C /usr/local/bin/ --strip=1 shellcheck-stable/shellcheck
    sudo chown root:root /usr/local/bin/shellcheck
    sudo chmod +x /usr/local/bin/shellcheck
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install shellcheck
    ;;
esac
