#!/bin/bash
set -eu -o pipefail

echo 'Install The Platinum Searcher'
pt_latest=$(
  curl -sSI https://github.com/monochromegane/the_platinum_searcher/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^Location:/{print $NF}'
)
curl -L# "https://github.com/monochromegane/the_platinum_searcher/releases/download/${pt_latest}/pt_linux_amd64.tar.gz" \
  | sudo tar xzf - -C /usr/local/bin/ --strip=1 pt_linux_amd64/pt
