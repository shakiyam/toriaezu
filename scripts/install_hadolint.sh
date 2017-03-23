#!/bin/bash
set -eu -o pipefail

# Install hadolint

# hadolint_latest=$(
#   curl -sSI https://github.com/lukasmartinelli/hadolint/releases/latest |
#     tr -d '\r' |
#     awk -F'/' '/^Location:/{print $NF}'
# )
# curl -L# "https://github.com/lukasmartinelli/hadolint/releases/download/${hadolint_latest}/hadolint_linux_amd64" > /usr/local/bin/hadolint
# chmod +x /usr/local/bin/hadolint
