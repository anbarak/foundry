#!/usr/bin/env bash
# benchmark-toggle.sh — pick model via FZF and run benchmark directly

set -euo pipefail

QUIT_LABEL="❌ Quit"
model=$(
  (
    ollama list | awk 'NR>1 {print $1}'
    echo "$QUIT_LABEL"
  ) | fzf --ansi --prompt="Benchmark which model? "
)

[[ -z "$model" || "$model" == "$QUIT_LABEL" ]] && echo "👋 Exiting." && exit 0

"$HOME/bin/tools/ai/benchmark-wrap.sh" "$model"
