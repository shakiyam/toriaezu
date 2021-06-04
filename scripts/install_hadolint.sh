#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(
  . /etc/os-release
  echo "$VERSION"
)
readonly OS_VERSION

echo 'Install hadolint'
if [[ $(uname -m) == 'aarch64' ]]; then
  echo 'hadolint is not yet supported on ARM.'
  exit 0
fi
if [[ ${OS_ID:-} == 'ol' && ${OS_VERSION%%.*} -eq 7 ]]; then
  sudo docker pull hadolint/hadolint
  sudo cp "$(dirname "$0")/../bin/hadolint" /usr/local/bin/hadolint
else
  LATEST=$(
    curl -sSI https://github.com/hadolint/hadolint/releases/latest \
      | tr -d '\r' \
      | awk -F'/' '/^[Ll]ocation:/{print $NF}'
  )
  readonly LATEST
  curl -L# "https://github.com/hadolint/hadolint/releases/download/${LATEST}/hadolint-Linux-x86_64" \
    | sudo tee /usr/local/bin/hadolint >/dev/null
fi
sudo chmod +x /usr/local/bin/hadolint
