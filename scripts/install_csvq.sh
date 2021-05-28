#!/bin/bash
set -eu -o pipefail

echo 'Install csvq'
LATEST=$(
  curl -sSI https://github.com/mithrandie/csvq/releases/latest \
    | tr -d '\r' \
    | awk -F'/' '/^[Ll]ocation:/{print $NF}'
)
readonly LATEST
case $(uname -m) in
  x86_64)
    ARCHITECTURE=amd64
    ;;
  aarch64)
    ARCHITECTURE=arm
    ;;
esac
readonly ARCHITECTURE
curl -L# "https://github.com/mithrandie/csvq/releases/download/${LATEST}/csvq-${LATEST}-linux-${ARCHITECTURE}.tar.gz" \
  | sudo tar xzf - -C /usr/local/bin/ --strip=1 "csvq-${LATEST}-linux-${ARCHITECTURE}/csvq"
sudo chown root:root /usr/local/bin/csvq
sudo chmod 755 /usr/local/bin/csvq
