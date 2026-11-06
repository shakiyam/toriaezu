#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID

echo_info 'Install zram swap'
case $OS_ID in
  ol)
    echo_warn 'zram swap is supported only on Ubuntu, skipping'
    exit 0
    ;;
  ubuntu)
    if dpkg -s zram-tools &>/dev/null; then
      echo_info 'Replace zram-tools with systemd-zram-generator'
      if ! is_container; then
        sudo systemctl disable --now zramswap
      fi
      sudo DEBIAN_FRONTEND=noninteractive apt-get purge -y zram-tools
    fi
    install_package systemd-zram-generator
    ;;
esac

echo_info 'Configure zram swap'
sudo mkdir -p /etc/systemd/zram-generator.conf.d
# Remove first: uutils install fails to overwrite from /dev/stdin (uutils/coreutils#11532)
sudo rm -f /etc/systemd/zram-generator.conf.d/50-toriaezu.conf
printf '[zram0]\nzram-size = ram / 2\ncompression-algorithm = zstd\nswap-priority = 100\n' \
  | sudo install -m 644 /dev/stdin /etc/systemd/zram-generator.conf.d/50-toriaezu.conf

# Swapping anonymous pages to zram is cheaper than rereading file pages from disk, and zram gains nothing from readahead
sudo rm -f /etc/sysctl.d/99-zram.conf
printf 'vm.swappiness = 150\nvm.page-cluster = 0\n' \
  | sudo install -m 644 /dev/stdin /etc/sysctl.d/99-zram.conf

if is_container; then
  echo_warn 'Running in container environment, skipping zram activation'
  exit 0
fi

echo_info 'Activate zram swap'
sudo systemctl daemon-reload
# Start instead of restart so that a re-run does not page swapped data back in; configuration changes apply at the next boot
sudo systemctl start dev-zram0.swap
sudo sysctl -p /etc/sysctl.d/99-zram.conf

echo_info 'Verify zram swap'
if swapon --show=NAME --noheadings | grep -qx /dev/zram0; then
  echo_success 'Verification passed: /dev/zram0 is used as swap'
else
  die 'Error: /dev/zram0 is not used as swap'
fi
