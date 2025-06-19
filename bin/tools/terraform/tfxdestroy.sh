#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: tfxdestroy <version> [terraform arguments...]"
  exit 1
fi

version="$1"
shift

logfile="destroy.log"

# Confirm destruction
echo "🛑 Type 'destroy' to confirm full resource destruction:"
read -r confirm
if [[ "$confirm" != "destroy" ]]; then
  echo "❌ Aborted."
  exit 1
fi

# Run destroy and log output
echo "🔥 Destroying infrastructure..."
tfx "$version" destroy "$@" | tee "$logfile"

# Display output
echo "📄 Destroy log:"
if command -v bat >/dev/null 2>&1; then
  bat --paging=never "$logfile"
else
  cat "$logfile"
fi
