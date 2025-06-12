#!/usr/bin/env bash
set -euo pipefail

# ── Setup log output ────────────────────────────────────────────
LOG_FILE="$HOME/logs/ollama-autostart.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1
exec 2>&1

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local level="$1"; shift; printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"; }

log INFO "🤖 Installing Ollama auto-start LaunchAgent..."

# ── Variables ───────────────────────────────────────────────────
OLLAMA_CMD="/opt/homebrew/bin/ollama"
PLIST_TEMPLATE="$HOME/bin/tools/ai/ollama-server.plist.template"
PLIST_DEST="$HOME/Library/LaunchAgents/dev.foundry.ollama-server.plist"
LOG_DIR="$HOME/logs"
DEFAULT_MODEL_FILE="$HOME/.local/state/foundry/ollama-default-model"

# ── Ensure prerequisites ────────────────────────────────────────
mkdir -p "$(dirname "$PLIST_DEST")"
chmod +x "$OLLAMA_CMD"
xattr -d com.apple.quarantine "$OLLAMA_CMD" 2>/dev/null || true

# ── Render and load plist ───────────────────────────────────────
export OLLAMA_CMD="$OLLAMA_CMD" LOG_DIR="$LOG_DIR"
envsubst < "$PLIST_TEMPLATE" > "$PLIST_DEST"

launchctl unload "$PLIST_DEST" 2>/dev/null || true
sleep 1
if launchctl load "$PLIST_DEST"; then
  log INFO "✅ LaunchAgent loaded: $PLIST_DEST"
else
  log ERROR "❌ Failed to load LaunchAgent: $PLIST_DEST"
  osascript -e 'display notification "❌ Failed to install Ollama LaunchAgent!" with title "LaunchAgent Setup" sound name "Funk"'
  exit 1
fi

# ── Health check ─────────────────
sleep 1
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
  ' "$HOME/logs/ollama-benchmark-subjective.log")
fi

if echo "Say hello" | "$OLLAMA_CMD" run "$DEFAULT_MODEL" | grep -iq "hello"; then
  osascript -e 'display notification "✅ Ollama autostart installed and verified." with title "LaunchAgent Setup"'
  log INFO "Ollama health check passed."
else
  osascript -e 'display notification "⚠️ Ollama may not have started yet." with title "LaunchAgent Setup"'
  log WARN "Health check failed or delayed; check manually if needed."
fi

# ── Preload default model to avoid cold start ─────────────────────
log INFO "⏱️ Preloading $DEFAULT_MODEL model..."
if ! "$OLLAMA_CMD" run "$DEFAULT_MODEL" >/dev/null 2>&1; then
  log WARN "Could not preload $DEFAULT_MODEL — may still be warming up."
else
  log INFO "✅ $DEFAULT_MODEL warmed up successfully."

  # ====== Record Last Success ======
  LABEL="$(basename "$0" .sh)"
  mkdir -p "$HOME/.cache/foundry"
  date +'%Y-%m-%d %H:%M:%S' > "$HOME/.cache/foundry/last-success-${LABEL}.txt"
fi
