#!/bin/bash
set -eEu -o pipefail

awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## .*\(\*\)$/ {print $1}' "$1"
