#!/bin/bash
set -eu -o pipefail

command -v fzy >/dev/null 2>&1 || { echo "ERROR: fzy is required for installation of enhancd."; exit 1; }

echo 'Install enhancd'
cd "$HOME"
git clone --depth 1 https://github.com/b4b4r07/enhancd
rm -rf enhancd/.git
