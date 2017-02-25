#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

# Install ShellCheck
case $os_id in
  ol | amzn)
    cp "$(cd "$(dirname "$0")/.." && pwd)/bin/shellcheck" /usr/local/bin/shellcheck
    chmod +x /usr/local/bin/shellcheck
    /usr/local/bin/shellcheck -V
    ;;
  ubuntu)
    apt-get install -y shellcheck
    ;;
esac
