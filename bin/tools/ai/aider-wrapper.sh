#!/usr/bin/env bash
# Wrapper to run Aider via Docker (under Colima) using local Ollama models
set -euo pipefail

MODEL="${AIDER_MODEL:-codellama:7b}"
OLLAMA_BIN="/opt/homebrew/bin/ollama"
OLLAMA_LOG="$HOME/logs/ollama.out.log"
OLLAMA_ERR="$HOME/logs/ollama.err.log"

# ── Ensure Ollama is running ─────────────────────────────────────
if ! pgrep -f "$OLLAMA_BIN serve" > /dev/null; then
  echo "⚙️ Starting Ollama..."
  nohup "$OLLAMA_BIN" serve > "$OLLAMA_LOG" 2> "$OLLAMA_ERR" &
  disown
  sleep 2
fi

# ── Ensure model is available ─────────────────────────────────────
if ! "$OLLAMA_BIN" list | grep -q "$MODEL"; then
  echo "❌ Required model '$MODEL' is not available in Ollama. Run: ollama pull $MODEL" >&2
  exit 1
fi

# ── Ensure Colima is running ─────────────────────────────────────
if ! colima status --json 2>/dev/null | jq -e '.docker_socket | test("docker.sock")' >/dev/null; then
  echo "❌ Colima is not running. Please start it first with: colima start" >&2
  exit 1
fi

# ── Launch Aider via Docker ──────────────────────────────────────
exec docker run --rm -it \
  --user "$(id -u):$(id -g)" \
  -v "$(pwd):/app" \
  paulgauthier/aider-full \
  --model "$MODEL" \
  "$@"
