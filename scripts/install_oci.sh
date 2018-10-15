#!/bin/bash
set -eu -o pipefail

echo 'Install OCI CLI'
bash -c "$(curl -L# https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
