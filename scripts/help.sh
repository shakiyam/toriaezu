#!/bin/bash
set -eu -o pipefail

echo 'Usage: make [target]'
echo ''
echo 'Targets:'
awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $1, $2}' "$1"
