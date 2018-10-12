#!/bin/bash
set -eu -o pipefail

if [ -e .env ]; then
  # shellcheck disable=SC1091
  . .env
fi

# shellcheck disable=SC1091
os_id=$(. /etc/os-release; echo "$ID")

echo 'Install s3fs'
case $os_id in
  ol)
    sudo yum -y install gcc-c++ fuse fuse-devel libcurl-devel libxml2-devel openssl-devel automake
    s3fs_latest=$(
      curl -sSI https://github.com/s3fs-fuse/s3fs-fuse/releases/latest |
        tr -d '\r' |
        awk -F'/' '/^Location:/{print $NF}'
    )
    temp_dir=$(mktemp -d)
    pushd "$temp_dir"
    curl -L# "https://github.com/s3fs-fuse/s3fs-fuse/archive/${s3fs_latest}.tar.gz" -o "${s3fs_latest}.tar.gz"
    tar xvzf "${s3fs_latest}.tar.gz"
    cd "s3fs-fuse-${s3fs_latest//v/}/"
    ./autogen.sh
    ./configure --prefix=/usr
    make
    sudo make install
    popd
    rm -rf "$temp_dir"
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install s3fs
    ;;
esac

echo 'Mount s3fs'
echo "$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY" | sudo tee /etc/passwd-s3fs >/dev/null
sudo chmod 640 /etc/passwd-s3fs
sudo mkdir -p "${MOUNT_POINT}"
sudo s3fs "$BUCKET" "${MOUNT_POINT}" -o rw,allow_other,uid="$(id -u)",gid="$(id -g)",default_acl=public-read
