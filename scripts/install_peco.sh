#!/bin/bash
set -eu -o pipefail

# Install peco
peco_latest=$(
  curl -sSI https://github.com/peco/peco/releases/latest |
  tr -d '\r' |
  awk -F'/' '/^Location:/{print $NF}'
)
curl -sSL "https://github.com/peco/peco/releases/download/${peco_latest}/peco_linux_amd64.tar.gz" |
  tar xzf - -C /usr/local/bin/ --strip=1 peco_linux_amd64/peco
