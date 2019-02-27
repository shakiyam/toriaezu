#!/bin/bash
set -eu -o pipefail

echo 'Install RuboCop'
sudo bash "$(dirname "$0")/../bin/rubocop" -v
sudo cp "$(dirname "$0")/../bin/rubocop" /usr/local/bin/rubocop
sudo chmod +x /usr/local/bin/rubocop
