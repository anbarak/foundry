#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: tfxinit <version> [optional init args]"
  exit 1
fi

version="$1"
shift

logfile="init.log"

echo "🚀 Initializing Terraform workspace..."
tfx "$version" init "$@" | tee "$logfile"

echo "📄 Init log:"
if command -v bat >/dev/null 2>&1; then
  bat --paging=never "$logfile"
else
  cat "$logfile"
fi
