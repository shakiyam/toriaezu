#!/bin/bash
set -eu -o pipefail

echo 'Install Docker Bench for Security'
bash "$(cd "$(dirname "$0")/.." && pwd)/bin/docker-bench-security.sh" -h
sudo cp "$(cd "$(dirname "$0")/.." && pwd)/bin/docker-bench-security.sh" /usr/local/bin/docker-bench-security.sh
sudo chmod +x /usr/local/bin/docker-bench-security.sh
