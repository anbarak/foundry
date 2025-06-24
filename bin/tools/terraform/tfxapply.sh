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

# Optional override of plan file
if [[ "${1:-}" == *.out ]]; then
  planfile="$1"
  shift
fi

if [[ ! -f "$planfile" ]]; then
  echo "❌ Plan file not found: $planfile"
  exit 1
fi

# Only generate JSON summary if version >= 0.14
if [[ "$(echo "$version" | cut -d. -f1)" -ge 1 || "$(echo "$version" | cut -d. -f2)" -ge 14 ]]; then
  jsonfile="apply.json"
  echo "📤 Generating apply JSON for summary..."
  if "$HOME/bin/runners/terraform-container" "$version" show -json "$planfile" | jq > "$jsonfile"; then
    echo "📊 Apply Summary:"
    "$HOME/bin/tools/terraform/tfxapply-summary.sh" "$jsonfile"
  else
    echo "⚠️  Failed to generate JSON summary"
  fi
else
  echo "⚠️  JSON plan summaries require Terraform >= 0.14 (current: $version). Skipping."
fi

# Confirm apply
echo "⚠️  Are you sure you want to apply this plan? (y/n)"
read -r confirm
if [[ "$confirm" != [yY]* ]]; then
  echo "❌ Aborted."
  exit 1
fi

# Run apply
echo "🚀 Applying plan: $planfile"
"$HOME/bin/runners/terraform-container" "$version" apply "$planfile" | tee "$logfile"

# Show log
echo "📄 Apply log:"
if command -v bat >/dev/null 2>&1; then
  bat --paging=never "$logfile"
else
  cat "$logfile"
fi
