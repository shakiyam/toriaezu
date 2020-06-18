#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
readonly OS_ID=$(. /etc/os-release; echo "$ID")
# shellcheck disable=SC1091
readonly OS_VERSION=$(. /etc/os-release; echo "$VERSION")

echo 'Install Git'
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      7)
        sudo yum -y remove git
        sudo yum -y localinstall https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
          https://repo.ius.io/ius-release-el7.rpm
        sudo yum-config-manager --disable epel ius
        sudo yum -y --enablerepo=ius install git222 
        ;;
      8)
        sudo dnf -y install git
        ;;
    esac
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install git
    ;;
esac

readonly GIT_VERSION=$(git --version | grep -E -o "[0-9]+.[0-9]+")
if [[ ${GIT_VERSION%%.*} -gt 2 ]] || [[ ${GIT_VERSION%%.*} -eq 2 && ${GIT_VERSION##*.} -gt 8 ]]; then
  git config --global user.useConfigOnly true
else
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
fi
