#!/bin/bash
set -eu -o pipefail

echo 'Install dockviz'
LATEST=$(
  curl -sSI https://github.com/justone/dockviz/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
/usr/local/go/bin/go install "github.com/justone/dockviz@$LATEST"
