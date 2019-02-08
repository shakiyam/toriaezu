#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install hadolint'
if [[ "$OS_ID" = 'ol' ]] && [[ "${OS_VERSION%%.*}" = '6' ]]; then
  sudo bash "$(cd "$(dirname "$0")/.." && pwd)/bin/hadolint" -v
  sudo cp "$(cd "$(dirname "$0")/.." && pwd)/bin/hadolint" /usr/local/bin/hadolint
else
  hadolint_latest=$(
    curl -sSI https://github.com/hadolint/hadolint/releases/latest \
      | tr -d '\r' \
      | awk -F'/' '/^Location:/{print $NF}'
  )
  curl -L# "https://github.com/hadolint/hadolint/releases/download/${hadolint_latest}/hadolint-Linux-x86_64" \
    | sudo tee /usr/local/bin/hadolint >/dev/null
fi
sudo chmod +x /usr/local/bin/hadolint
