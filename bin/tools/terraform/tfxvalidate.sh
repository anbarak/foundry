#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: tfxvalidate <version> [optional path]"
  exit 1
fi

version="$1"
shift

logfile="validate.log"

# Validate and capture output
echo "🔎 Validating Terraform configuration..."
tfx "$version" validate "$@" | tee "$logfile"

# Show output
echo "📄 Validate log:"
if command -v bat >/dev/null 2>&1; then
  bat --paging=never "$logfile"
else
  cat "$logfile"
fi
