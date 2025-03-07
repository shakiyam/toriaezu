#!/bin/bash
set -eu -o pipefail

case $(uname -m) in
  x86_64)
    ARCHITECTURE=x86_64
    ;;
  aarch64)
    ARCHITECTURE=arm64
    ;;
esac
readonly ARCHITECTURE

echo 'Install hadolint'
LATEST=$(
  curl -sSI https://github.com/hadolint/hadolint/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
curl -L# "https://github.com/hadolint/hadolint/releases/download/${LATEST}/hadolint-Linux-${ARCHITECTURE}" \
  | sudo tee /usr/local/bin/hadolint >/dev/null
sudo chmod +x /usr/local/bin/hadolint
