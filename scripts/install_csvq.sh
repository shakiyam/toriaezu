#!/bin/bash
set -eu -o pipefail

echo 'Install csvq'
readonly LATEST=$(
  curl -sSI https://github.com/mithrandie/csvq/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
curl -L# "https://github.com/mithrandie/csvq/releases/download/${LATEST}/csvq-${LATEST}-linux-amd64.tar.gz" \
  | sudo tar xzf - -C /usr/local/bin/ --strip=1 "csvq-${LATEST}-linux-amd64/csvq"
sudo chown root:root /usr/local/bin/csvq
sudo chmod 755 /usr/local/bin/csvq
