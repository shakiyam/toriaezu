#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install ShellCheck'
case $OS_ID in
  ol)
    curl -L# "https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.$(uname -m).tar.xz" \
      | sudo tar xJf - -C /usr/local/bin/ --strip=1 shellcheck-stable/shellcheck
    sudo chown root:root /usr/local/bin/shellcheck
    sudo chmod +x /usr/local/bin/shellcheck
    ;;
  ubuntu)
    install_package shellcheck
    ;;
esac
