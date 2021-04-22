#!/bin/bash
set -eu -o pipefail

echo 'Install dockviz'
LATEST=$(
  curl -sSI https://github.com/justone/dockviz/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
curl -L# "https://github.com/justone/dockviz/releases/download/${LATEST}/dockviz_linux_amd64" \
  | sudo tee /usr/local/bin/dockviz >/dev/null
sudo chmod +x /usr/local/bin/dockviz
