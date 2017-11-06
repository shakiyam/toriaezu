#!/bin/bash
set -eu -o pipefail

# Install hadolint

# hadolint_latest=$(
#   curl -sSI https://github.com/lukasmartinelli/hadolint/releases/latest |
#     tr -d '\r' |
#     awk -F'/' '/^Location:/{print $NF}'
# )
hadolint_latest=v1.2.1
curl -L# "https://github.com/lukasmartinelli/hadolint/releases/download/${hadolint_latest}/hadolint_linux_amd64" |
  sudo tee /usr/local/bin/hadolint >/dev/null
sudo chmod +x /usr/local/bin/hadolint
