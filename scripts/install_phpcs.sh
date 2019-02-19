#!/bin/bash
set -eu -o pipefail

echo 'Install PHP_CodeSniffer'
sudo bash "$(dirname "$0")/../bin/phpcs" --version
sudo cp "$(dirname "$0")/../bin/phpcs" /usr/local/bin/phpcs
sudo chmod +x /usr/local/bin/phpcs
