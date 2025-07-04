#!/usr/bin/env bash
set -euo pipefail

# ── Setup log output ────────────────────────────────────────────
LOG_FILE="$HOME/logs/ollama-install-check.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local level="$1"; shift; printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"; }

log INFO "🔧 Verifying Ollama installation..."

# ── Variables ───────────────────────────────────────────────────
OLLAMA_CMD="/opt/homebrew/bin/ollama"
DEFAULT_MODEL_FILE="$HOME/.local/state/foundry/ollama-default-model"

# ── Ensure prerequisites ────────────────────────────────────────
chmod +x "$OLLAMA_CMD"
xattr -d com.apple.quarantine "$OLLAMA_CMD" 2>/dev/null || true
log INFO "✅ Ollama CLI is ready."

# ── Determine model to test ─────────────────────────────────────
if [[ -f "$DEFAULT_MODEL_FILE" ]]; then
  DEFAULT_MODEL=$(<"$DEFAULT_MODEL_FILE")
else
  DEFAULT_MODEL=$(awk -F'|' '
    function strip(s) { gsub(/^ *| *$/, "", s); return s }
    {
      correct = ($4 ~ /✅/) ? strip($4) + 0 : 0
      clarity = ($5 ~ /✨/) ? strip($5) + 0 : 0
      total = correct + clarity
      model = strip($2)
      if (total > max_score) {
        max_score = total
        best = model
      }
    }
    END { print best }
  ' "$HOME/logs/ollama-benchmark-subjective.log" 2>/dev/null || echo "llama3")
fi

# ── Health check ────────────────────────────────────────────────
log INFO "🧪 Testing model: $DEFAULT_MODEL"
if echo "Say hello" | "$OLLAMA_CMD" run "$DEFAULT_MODEL" | grep -iq "hello"; then
  log INFO "✅ Ollama is working with $DEFAULT_MODEL"
else
  log WARN "⚠️ Ollama test failed. Start it manually with: start-ollama"
fi

# ── Record success ──────────────────────────────────────────────
LAST_SUCCESS_FILE="$HOME/.cache/foundry/last-success-install-ai-tools.txt"
mkdir -p "$(dirname "$LAST_SUCCESS_FILE")"
date +'%Y-%m-%d %H:%M:%S' > "$LAST_SUCCESS_FILE"
log INFO "📌 Success recorded at $LAST_SUCCESS_FILE"
