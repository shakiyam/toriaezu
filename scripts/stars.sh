#!/bin/bash
set -eu -o pipefail

awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## .*\(\*\)$/ {print $1}' "$1"
