#!/bin/bash
set -eu -o pipefail

command -v fzy >/dev/null 2>&1 || { echo "ERROR: fzy is required for installation of enhancd."; exit 1; }

echo 'Install enhancd'
cd "$HOME"
mkdir -p enhancd
curl -L# https://github.com/b4b4r07/enhancd/archive/master.tar.gz \
  | tar xzf - -C ./enhancd enhancd-master --strip=1
