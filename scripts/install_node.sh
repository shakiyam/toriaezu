#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install Node.js'
# Check the latest version from https://nodejs.org/en/ and https://github.com/nodesource/distributions
case $os_id in
  ol)
    curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
    sudo yum -y install nodejs gcc-c++ make
    curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo >/dev/null
    sudo yum -y install yarn
    ;;
  ubuntu)
    curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
    sudo apt -y install nodejs build-essential
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt -y install yarn
    ;;
esac
