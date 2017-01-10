#!/bin/bash

# Install Docker Engine
apt-get update
apt-get install -y docker.io

# # Install Latest Docker Engine
# apt-get update
# apt-get install -y apt-transport-https ca-certificates
# apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# cat > /etc/apt/sources.list.d/docker.list <<EOT
# deb https://apt.dockerproject.org/repo ubuntu-xenial main
# EOT
# apt-get update
# apt-get purge lxc-docker
# apt-cache policy docker-engine
# apt-get -y install "linux-image-extra-$(uname -r)" linux-image-extra-virtual
# apt-get -y install docker-engine

## Setup Docker Engine
usermod -aG docker "$(logname)"
systemctl start docker
systemctl enable docker

# Install Docker Compose
docker_compose_latest=$(
  curl -sSI https://github.com/docker/compose/releases/latest |
    tr -d '\r' |
    awk -F'/' '/^Location:/{print $NF}'
)
curl -sSL "https://github.com/docker/compose/releases/download/${docker_compose_latest}/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install dockviz
dockviz_latest=$(
  curl -sSI https://github.com/justone/dockviz/releases/latest |
    tr -d '\r' |
    awk -F'/' '/^Location:/{print $NF}'
)
curl -sSL "https://github.com/justone/dockviz/releases/download/${dockviz_latest}/dockviz_linux_amd64" > /usr/local/bin/dockviz
chmod +x /usr/local/bin/dockviz

# Install hadolint
hadolint_latest=$(
  curl -sSI https://github.com/lukasmartinelli/hadolint/releases/latest |
    tr -d '\r' |
    awk -F'/' '/^Location:/{print $NF}'
)
curl -sSL "https://github.com/lukasmartinelli/hadolint/releases/download/${hadolint_latest}/hadolint_linux_amd64" > /usr/local/bin/hadolint
chmod +x /usr/local/bin/hadolint

# Install git
# apt-get install -y git

# Install Q (http://harelba.github.io/q/install.html)
apt-get install -y python-minimal
curl -sSO https://github.com/harelba/packages-for-q/raw/master/deb/q-text-as-data_1.5.0-1_all.deb
dpkg -i q-text-as-data_1.5.0-1_all.deb
rm q-text-as-data_1.5.0-1_all.deb

# Install peco
peco_latest=$(
  curl -sSI https://github.com/peco/peco/releases/latest |
  tr -d '\r' |
  awk -F'/' '/^Location:/{print $NF}'
)
curl -sSL "https://github.com/peco/peco/releases/download/${peco_latest}/peco_linux_amd64.tar.gz" |
  tar xzf - -C /usr/local/bin/ --strip=1 peco_linux_amd64/peco

# Install Go Programming Language
apt-get install -y golang

# Install ShellCheck
apt-get install -y shellcheck

# Install Micro
micro_latest=$(
  curl -sSI https://github.com/zyedidia/micro/releases/latest |
  tr -d '\r' |
  awk -F'/' '/^Location:/{print $NF}'
)
curl -sSL "https://github.com/zyedidia/micro/releases/download/${micro_latest}/micro-${micro_latest//v/}-linux64.tar.gz" |
  tar xzf - -C /usr/local/bin/ --strip=1 "micro-${micro_latest//v/}/micro"

# Copy dotfiles
cp .bashrc "/home/$(logname)/.bashrc"
chown "$(logname)":"$(id -g "$(logname)")" "/home/$(logname)/.bashrc"
cp .tmux.conf "/home/$(logname)/.tmux.conf"
chown "$(logname)":"$(id -g "$(logname)")" "/home/$(logname)/.tmux.conf"
