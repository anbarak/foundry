#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: tfxplan <version> [terraform arguments...]"
  exit 1
fi

version="$1"
shift

outfile="plan.out"
jsonfile="plan.json"

"$HOME/bin/runners/terraform-container" "$version" plan -out="$outfile" "$@"

echo "📤 Showing plan JSON:"
"$HOME/bin/runners/terraform-container" "$version" show -json "$outfile" | jq > "$jsonfile"

if command -v bat >/dev/null 2>&1; then
  bat --paging=never --language=json "$jsonfile"
else
  cat "$jsonfile"
fi
