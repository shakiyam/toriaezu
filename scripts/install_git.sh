#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")

echo 'Install Git'
case $OS_ID in
  ol)
    sudo yum -y install git
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install git
    ;;
esac

if [[ ! -f "$HOME/.gitconfig" ]]; then
  echo 'Can not find .gitconfig file'
  read -r -p 'continue? ' ans
  case "$ans" in
    [yY]*)
      ;;
    *)
      echo 'abort'
      exit 1
      ;;
  esac
fi
