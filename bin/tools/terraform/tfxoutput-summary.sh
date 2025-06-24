#!/usr/bin/env bash
set -euo pipefail
file="${1:-output.json}"

jq -r '
  ["NAME", "VALUE", "SENSITIVE"],
  to_entries[] | [.key, (.value.value|tostring), (.value.sensitive|tostring)]
  | @tsv
' "$file" | column -t
