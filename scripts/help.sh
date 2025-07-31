#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/colored_echo.sh"

echo_info 'Usage: make [target]'
echo ''
echo_info 'Targets:'
awk 'BEGIN {FS = ":.*?## "} /^[0-9A-Za-z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $1, $2}' "$1"
