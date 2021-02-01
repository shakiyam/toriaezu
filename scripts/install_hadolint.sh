#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install hadolint'
if [[ ${OS_ID:-} == 'ol' && ${OS_VERSION%%.*} -eq 7 ]]; then
  readonly LATEST=v1.19.0
else
  readonly LATEST=$(
    curl -sSI https://github.com/hadolint/hadolint/releases/latest \
      | tr -d '\r' \
      | awk -F'/' '/^[Ll]ocation:/{print $NF}'
  )
fi
curl -L# "https://github.com/hadolint/hadolint/releases/download/${LATEST}/hadolint-Linux-x86_64" \
  | sudo tee /usr/local/bin/hadolint >/dev/null
sudo chmod +x /usr/local/bin/hadolint
