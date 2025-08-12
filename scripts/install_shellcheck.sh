#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install ShellCheck'
case $OS_ID in
  ol)
    curl -fL# "https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.$(uname -m).tar.xz" \
      | tar xJf - -O shellcheck-stable/shellcheck | sudo install -m 755 /dev/stdin /usr/local/bin/shellcheck
    ;;
  ubuntu)
    install_package shellcheck
    ;;
esac

echo_info 'Verify ShellCheck installation'
verify_command shellcheck
