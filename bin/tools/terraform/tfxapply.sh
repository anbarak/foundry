#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: tfxapply <version> [terraform arguments...]"
  exit 1
fi

version="$1"
shift

planfile="plan.out"
logfile="apply.log"

# Confirm before applying
echo "⚠️  Are you sure you want to apply this plan? (y/n)"
read -r confirm
if [[ "$confirm" != [yY]* ]]; then
  echo "❌ Aborted."
  exit 1
fi

# Apply and capture output
echo "🚀 Applying plan..."
tfx "$version" apply "$planfile" | tee "$logfile"

# Display result
echo "📄 Apply log:"
if command -v bat >/dev/null 2>&1; then
  bat --paging=never "$logfile"
else
  cat "$logfile"
fi
