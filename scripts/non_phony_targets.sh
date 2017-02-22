#!/bin/bash
set -eu -o pipefail

all_targets=$(mktemp)
egrep -o ^[a-zA-Z_-]+: "$1" | sed 's/://' | sort > "$all_targets"

phony_targets=$(mktemp)
awk '/^\.PHONY:/ {sub(/^\.PHONY:/, ""); gsub(/ /, "\n"); print}' "$1" | sort | sed '/^$/d' > "$phony_targets"

grep -F -x -v -f "$phony_targets" "$all_targets"
rm "$all_targets" "$phony_targets"
