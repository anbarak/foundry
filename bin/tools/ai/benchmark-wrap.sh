#!/usr/bin/env bash
# benchmark-wrap.sh — full launcher for all benchmark utilities

set -euo pipefail

LOG_FILE="$HOME/logs/ollama-benchmark-subjective.log"
touch "$LOG_FILE"

# If a model is passed as an argument, run the benchmark directly
if [[ $# -eq 1 ]]; then
  selected_model="$1"
  echo "🔁 Running full benchmark for model: $selected_model"
  echo "🧪 Running benchmark on: $(uname -m) $(sysctl -n machdep.cpu.brand_string)"
  echo "📄 Prompt: $(cat "$HOME/benchmark-prompt.txt")"
  echo "──────────────────────────────"
  "$HOME/bin/tools/ai/benchmark-models.sh" "$selected_model"
  exit 0
fi

# Show recent durations in header
duration_summary() {
  grep -Eo '^.+\| ([^|]+) \| ([^|]+)s' "$LOG_FILE" | tail -n 5 | sed 's/^/⏱ /'
}

# Show latest benchmark log entries
fzf_preview() {
  tail -n 20 "$LOG_FILE" | tac
}

options=$(printf "%s\n" \
  "🧪 Run new benchmark" \
  "📜 View benchmark history" \
  "🔍 Compare two models" \
  "🔁 Repeat last benchmarked model" \
  "❌ Quit")

selected=$(echo "$options" | fzf \
  --ansi \
  --prompt="Benchmark menu: " \
  --preview-window=right:60% \
  --preview="tail -n 20 $LOG_FILE | tac" \
  --header="$(duration_summary)")

case "$selected" in
  *"Run new benchmark"*)
    "$HOME/bin/tools/ai/benchmark-models.sh"
    ;;
  *"View benchmark history"*)
    "$HOME/bin/tools/ai/benchmark-viewer.sh"
    ;;
  *"Compare two models"*)
    "$HOME/bin/tools/ai/benchmark-diff.sh"
    ;;
  *"Repeat last benchmarked model"*)
    last_model=$(tail -n 1 "$LOG_FILE" | cut -d '|' -f2 | xargs)
    if [[ -n "$last_model" ]]; then
      echo "🔁 Re-running last benchmark with: $last_model"
      "$HOME/bin/tools/ai/benchmark-models.sh" "$last_model"
    else
      echo "❌ No previous model found."
    fi
    ;;
  *"Quit"*)
    echo "👋 Exiting."
    ;;
  *)
    echo "⚠️ Invalid choice."
    ;;
esac
