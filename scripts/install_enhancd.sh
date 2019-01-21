#!/bin/bash
set -eu -o pipefail

command -v fzy >/dev/null 2>&1 || { echo "ERROR: fzy is required for installation of enhancd."; exit 1; }

echo 'Install enhancd'
temp_dir=$(mktemp -d)
pushd "$temp_dir"
git clone --depth 1 https://github.com/b4b4r07/enhancd
rm -rf enhancd/.git
sudo cp -r enhancd /opt/enhancd
popd
rm -rf "$temp_dir"
