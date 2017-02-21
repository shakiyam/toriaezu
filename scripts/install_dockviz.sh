#!/bin/bash
set -eu -o pipefail

# Install dockviz
dockviz_latest=$(
  curl -sSI https://github.com/justone/dockviz/releases/latest |
    tr -d '\r' |
    awk -F'/' '/^Location:/{print $NF}'
)
curl -sSL "https://github.com/justone/dockviz/releases/download/${dockviz_latest}/dockviz_linux_amd64" > /usr/local/bin/dockviz
chmod +x /usr/local/bin/dockviz
