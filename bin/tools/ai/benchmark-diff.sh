#!/usr/bin/env bash
set -euo pipefail

CSV="$HOME/logs/ollama-benchmark.csv"
model1=$(awk -F, 'NR > 1 { print $2 }' "$CSV" | sort -u | fzf --prompt="Select first model: ")
model2=$(awk -F, 'NR > 1 { print $2 }' "$CSV" | grep -v "$model1" | sort -u | fzf --prompt="Select second model: ")

echo "🔍 Comparing: $model1 vs $model2"
echo ""

awk -F, -v m1="$model1" -v m2="$model2" '
BEGIN { score1=0; score2=0; c1=0; c2=0 }
$2 == m1 { score1 += $4 + $5; c1++ }
$2 == m2 { score2 += $4 + $5; c2++ }
END {
  printf "🏁 %-20s | Avg Score: %.2f (%d entries)\n", m1, (c1 ? score1/c1 : 0), c1
  printf "🏁 %-20s | Avg Score: %.2f (%d entries)\n", m2, (c2 ? score2/c2 : 0), c2
  printf "\n%s\n", (score1/c1 > score2/c2) ? "✅ Recommended: " m1 : "✅ Recommended: " m2
}' "$CSV"
