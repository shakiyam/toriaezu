#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
.  "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install Node.js'
# Check the latest version from https://nodejs.org/en/
case $OS_ID in
  ol)
    case $(uname -m) in
      x86_64)
        ARCHITECTURE=x86_64
        ;;
      aarch64)
        ARCHITECTURE=aarch64
        ;;
    esac
    readonly ARCHITECTURE

    sudo curl -fsSL https://rpm.nodesource.com/gpgkey/ns-operations-public.key \
      -o /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL
    sudo rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL
    sudo tee /etc/yum.repos.d/nodesource-el.repo <<'EOF' >/dev/null
[nodesource]
name=Node.js Packages for Enterprise Linux - $basearch
baseurl=https://rpm.nodesource.com/pub_22.x/nodistro/nodejs/$basearch
priority=9
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL
module_hotfixes=1
EOF
    sudo sed -i "s/\$basearch/$ARCHITECTURE/g" /etc/yum.repos.d/nodesource-el.repo
    install_package nodejs gcc-c++ make
    ;;
  ubuntu)
    install_package gnupg
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
      | sudo gpg --yes --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" \
      | sudo tee /etc/apt/sources.list.d/nodesource.list >/dev/null
    sudo chmod 644 /etc/apt/keyrings/nodesource.gpg /etc/apt/sources.list.d/nodesource.list
    install_package nodejs build-essential
    ;;
esac
