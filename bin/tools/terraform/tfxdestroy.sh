#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: tfxdestroy <version> [optional args...]"
  exit 1
fi

version="$1"
shift

planfile="destroy.out"
jsonfile="destroy.json"
logfile="destroy.log"

# Generate destroy plan
echo "📦 Generating destroy plan..."
"$HOME/bin/runners/terraform-container" "$version" plan -destroy -out="$planfile" "$@"

# Generate JSON summary if supported
if [[ "$(echo "$version" | cut -d. -f1)" -ge 1 || "$(echo "$version" | cut -d. -f2)" -ge 14 ]]; then
  echo "📤 Generating destroy JSON for summary..."
  "$HOME/bin/runners/terraform-container" "$version" show -json "$planfile" | jq > "$jsonfile"

  echo "📊 Destroy Summary:"
  "$HOME/bin/tools/terraform/tfxdestroy-summary.sh" "$jsonfile"
else
  echo "⚠️  Skipping JSON summary (Terraform < 0.14)"
fi

# Confirm
echo "🛑 Type 'destroy' to confirm full resource destruction:"
read -r confirm
if [[ "$confirm" != "destroy" ]]; then
  echo "❌ Aborted."
  exit 1
fi

# Apply destroy plan
echo "🔥 Destroying infrastructure..."
"$HOME/bin/runners/terraform-container" "$version" apply "$planfile" | tee "$logfile"

# Show log
echo "📄 Destroy log:"
if command -v bat >/dev/null 2>&1; then
  bat --paging=never "$logfile"
else
  cat "$logfile"
fi
