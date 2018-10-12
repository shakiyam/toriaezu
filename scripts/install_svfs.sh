#!/bin/bash
set -eu -o pipefail

if [ -e .env ]; then
  # shellcheck disable=SC1091
  . .env
fi

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install svfs'
# Check the latest version from https://github.com/ovh/svfs/releases
case $os_id in
  ol)
    # TODO: Oracle Linux 6's ruby is too old
    sudo yum -y install ruby fuse
    sudo yum -y localinstall https://github.com/ovh/svfs/releases/download/v0.9.1/svfs-0.9.1-1.x86_64.rpm
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install ruby
    FILE=$(mktemp)
    curl -L# https://github.com/ovh/svfs/releases/download/v0.9.1/svfs_0.9.1_amd64.deb -o "$FILE"
    sudo dpkg -i "$FILE"
    rm "$FILE"
    ;;
esac

echo 'Mount by svfs'
cat <<EOT | sudo tee /etc/svfs.yaml >/dev/null
os_auth_url: ${SVFS_AUTH_URL}
os_username: ${SVFS_USERNAME}
os_password: ${SVFS_PASSWORD}
EOT
sudo chmod 640 /etc/svfs.yaml
sudo mkdir -p "${SVFS_MOUNT_POINT}"
sudo mount -t svfs -o rw,allow_other,uid="$(id -u)",gid="$(id -g)" svfs "${SVFS_MOUNT_POINT}"
