#!/usr/bin/env bash
# benchmark-viewer.sh — show recent subjective benchmark results

set -euo pipefail

LOG_FILE="$HOME/logs/ollama-benchmark-subjective.log"

if [[ ! -s "$LOG_FILE" ]]; then
  echo "📭 No benchmark data found."
  exit 0
fi

echo "📊 Benchmark History ▸"
echo

# Print table header
printf "%-20s  %-23s  %-18s %4s %4s %4s\n" "Timestamp" "Model" "Duration" "✔" "✨" "Σ"
echo "────────────────────────────────────────────────────────────────────────────────────────────"

awk -F'\\|' '
function trim(s) {
  sub(/^[ \t]+/, "", s)
  sub(/[ \t]+$/, "", s)
  return s
}
{
  ts = trim($1)
  model = trim($2)
  dur = trim($3)
  gsub(/[^0-9.]/, "", dur)

  correct = 0
  if ($4 ~ /✅/) {
    sub(/.*✅ */, "", $4)
    correct = trim($4)
  }

  clarity = 0
  if ($5 ~ /✨/) {
    sub(/.*✨ */, "", $5)
    clarity = trim($5)
  }

  total = correct + clarity

  printf "%-20s  %-23s  ⏱️  %-12ss %3s %3s %3s\n", ts, model, dur, correct, clarity, total
}
' "$LOG_FILE" | sort -k6 -nr
