#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: tfx-run <version> <command> [args...]"
  exit 1
fi

version="$1"; shift
command="$1"; shift
logfile="${command}.log"

"$HOME/bin/runners/terraform-container" "$version" "$command" "$@" | tee "$logfile"

echo "📄 ${command^} log:"
if command -v bat >/dev/null 2>&1; then
  bat --paging=never "$logfile"
else
  cat "$logfile"
fi
