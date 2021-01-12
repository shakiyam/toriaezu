#!/bin/bash
set -eu -o pipefail

echo 'Install hadolint'
readonly LATEST=$(
  curl -sSI https://github.com/hadolint/hadolint/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
curl -L# "https://github.com/hadolint/hadolint/releases/download/${LATEST}/hadolint-Linux-x86_64" \
  | sudo tee /usr/local/bin/hadolint >/dev/null
sudo chmod +x /usr/local/bin/hadolint
