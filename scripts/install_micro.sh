#!/bin/bash
set -eu -o pipefail

# Install Micro
micro_latest=$(
  curl -sSI https://github.com/zyedidia/micro/releases/latest |
  tr -d '\r' |
  awk -F'/' '/^Location:/{print $NF}'
)
curl -sSL "https://github.com/zyedidia/micro/releases/download/${micro_latest}/micro-${micro_latest//v/}-linux64.tar.gz" |
  tar xzf - -C /usr/local/bin/ --strip=1 "micro-${micro_latest//v/}/micro"
