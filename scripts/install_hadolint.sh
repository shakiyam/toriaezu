#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
os_version=$(. /etc/os-release; echo "$VERSION")

echo 'Install hadolint'
if [ "$os_id" = 'ol' ] && [ "${os_version%%.*}" = '6' ] ; then
  sh "$(cd "$(dirname "$0")/.." && pwd)/bin/hadolint" -v
  sudo cp "$(cd "$(dirname "$0")/.." && pwd)/bin/hadolint" /usr/local/bin/hadolint
else
  # hadolint_latest=$(
  #   curl -sSI https://github.com/lukasmartinelli/hadolint/releases/latest |
  #     tr -d '\r' |
  #     awk -F'/' '/^Location:/{print $NF}'
  # )
  hadolint_latest=v1.2.1
  curl -L# "https://github.com/lukasmartinelli/hadolint/releases/download/${hadolint_latest}/hadolint_linux_amd64" |
    sudo tee /usr/local/bin/hadolint >/dev/null
fi
sudo chmod +x /usr/local/bin/hadolint
