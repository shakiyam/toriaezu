#!/bin/bash
set -eu -o pipefail

echo_error() {
  if [[ -t 1 ]]; then
    echo -e "\033[1;31m$*\033[0m" # Bold Red
  else
    echo "$@"
  fi
}

echo_warn() {
  if [[ -t 1 ]]; then
    echo -e "\033[1;33m$*\033[0m" # Bold Yellow
  else
    echo "$@"
  fi
}

echo_info() {
  if [[ -t 1 ]]; then
    echo -e "\033[36m$*\033[0m" # Cyan
  else
    echo "$@"
  fi
}

echo_success() {
  if [[ -t 1 ]]; then
    echo -e "\033[32m$*\033[0m" # Green
  else
    echo "$@"
  fi
}
