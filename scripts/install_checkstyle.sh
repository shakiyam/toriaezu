#!/bin/bash
set -eu -o pipefail

echo 'Install Checkstyle'
latest=$(
  curl -sSI https://github.com/checkstyle/checkstyle/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^Location:/{print $NF}'
)
sudo mkdir -p /usr/local/lib/checkstyle
curl -L# "https://github.com/checkstyle/checkstyle/releases/download/${latest}/${latest}-all.jar" \
  | sudo tee /usr/local/lib/checkstyle/checkstyle.jar >/dev/null
sudo cp "$(dirname "$0")/../bin/checkstyle" /usr/local/bin/checkstyle
sudo chmod +x /usr/local/bin/checkstyle
