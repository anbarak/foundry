#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: tfxfmt <version> [--check or other args]"
  exit 1
fi

version="$1"
shift

logfile="fmt.log"

echo "🧹 Running Terraform fmt..."
"$HOME/bin/runners/terraform-container" "$version" fmt "$@" | tee "$logfile"

echo "📄 Fmt log:"
if command -v bat >/dev/null 2>&1; then
  bat --paging=never "$logfile"
else
  cat "$logfile"
fi
