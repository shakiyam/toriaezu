#!/bin/bash
set -eu -o pipefail

echo 'Install The Platinum Searcher'
readonly LATEST=$(
  curl -sSI https://github.com/monochromegane/the_platinum_searcher/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
curl -L# "https://github.com/monochromegane/the_platinum_searcher/releases/download/${LATEST}/pt_linux_amd64.tar.gz" \
  | sudo tar xzf - -C /usr/local/bin/ --strip=1 pt_linux_amd64/pt
