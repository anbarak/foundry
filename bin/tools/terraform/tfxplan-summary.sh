#!/usr/bin/env bash
set -euo pipefail
file="${1:-plan.json}"

jq -r '
  ["ACTION", "TYPE", "NAME", "ADDRESS"],
  (.resource_changes[] | [.change.actions[0], .type, .name, .address])
  | @tsv
' "$file" | column -t
