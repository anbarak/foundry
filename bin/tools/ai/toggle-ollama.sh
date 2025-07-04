#!/usr/bin/env bash
set -euo pipefail

OLLAMA_BIN="/opt/homebrew/bin/ollama"
LOG_FILE="$HOME/logs/ollama.out.log"
ERR_FILE="$HOME/logs/ollama.err.log"

if pgrep -f "$OLLAMA_BIN serve" > /dev/null; then
  pkill -f "$OLLAMA_BIN serve"
  echo "🛑 Ollama stopped."
else
  nohup "$OLLAMA_BIN" serve > "$LOG_FILE" 2> "$ERR_FILE" &
  disown
  echo "🚀 Ollama started."
fi
