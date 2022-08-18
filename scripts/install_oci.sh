#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(
  . /etc/os-release
  echo "$VERSION"
)
readonly OS_VERSION

echo 'Install OCI CLI'
if [[ ${OS_ID:-} == 'ol' && ${OS_VERSION%%.*} -gt 8 ]]; then
  case ${OS_VERSION%%.*} in
    8)
      sudo dnf -y install oraclelinux-developer-release-el8
      sudo dnf -y install python36-oci-cli
      ;;
    9)
      sudo dnf -y install oraclelinux-developer-release-el9
      sudo dnf -y install python39-oci-cli
      ;;
  esac
else
  readonly IMAGE_NAME='docker.io/shakiyam/oci-cli'
  [[ $(command -v docker) ]] || {
    echo -e "\033[36mdocker not found\033[0m"
    exit 1
  }
  sudo -u "$(id -un)" docker pull $IMAGE_NAME
  curl -L# https://raw.githubusercontent.com/shakiyam/oci-cli-docker/master/oci \
    | sudo tee /usr/local/bin/oci >/dev/null
  sudo chmod +x /usr/local/bin/oci
fi
