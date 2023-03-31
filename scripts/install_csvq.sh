#!/bin/bash
set -eu -o pipefail

echo 'Install csvq'
LATEST=$(
  curl -sSI https://github.com/mithrandie/csvq/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
/usr/local/go/bin/go install "github.com/mithrandie/csvq@$LATEST"
