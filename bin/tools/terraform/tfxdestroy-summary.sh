#!/usr/bin/env bash
set -euo pipefail
file="${1:-destroy.json}"

jq -r '
  ["ACTION", "TYPE", "NAME", "ADDRESS"],
  (.resource_changes[] | select(.change.actions[] == "delete") | [.change.actions[0], .type, .name, .address])
  | @tsv
' "$file" | column -t
