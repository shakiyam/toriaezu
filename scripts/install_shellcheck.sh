#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install ShellCheck'
case $OS_ID in
  ol)
    sudo bash "$(cd "$(dirname "$0")/.." && pwd)/bin/shellcheck" -V
    sudo cp "$(cd "$(dirname "$0")/.." && pwd)/bin/shellcheck" /usr/local/bin/shellcheck
    sudo chmod +x /usr/local/bin/shellcheck
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install shellcheck
    ;;
esac
