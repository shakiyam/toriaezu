#!/bin/bash
set -eu -o pipefail

echo 'Install Wercker CLI'
curl -L# https://s3.amazonaws.com/downloads.wercker.com/cli/stable/linux_amd64/wercker \
  | sudo tee /usr/local/bin/wercker >/dev/null
sudo chmod +x /usr/local/bin/wercker
