#!/bin/bash
set -eu -o pipefail

echo 'Install Q'
# readonly LATEST=$(
#   curl -sSI https://github.com/harelba/q/releases/latest \
#     | tr -d '\r' \
#     | awk -F'/' '/^location:/{print $NF}'
# )
readonly LATEST=2.0.9 # 2.0.10 and 2.0.11 is not stable
curl -L# "https://github.com/harelba/q/releases/download/${LATEST}/q-x86_64-Linux" \
  | sudo tee /usr/local/bin/q >/dev/null
sudo chmod +x /usr/local/bin/q
