#!/bin/bash
set -eu -o pipefail

echo 'Install hadolint'
latest=$(
  curl -sSI https://github.com/hadolint/hadolint/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^Location:/{print $NF}'
)
curl -L# "https://github.com/hadolint/hadolint/releases/download/${latest}/hadolint-Linux-x86_64" \
  | sudo tee /usr/local/bin/hadolint >/dev/null
sudo chmod +x /usr/local/bin/hadolint
