#!/bin/bash
set -eu -o pipefail

echo 'Install dockviz'
dockviz_latest=$(
  curl -sSI https://github.com/justone/dockviz/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^Location:/{print $NF}'
)
curl -L# "https://github.com/justone/dockviz/releases/download/${dockviz_latest}/dockviz_linux_amd64" \
  | sudo tee /usr/local/bin/dockviz >/dev/null
sudo chmod +x /usr/local/bin/dockviz
