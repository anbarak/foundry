#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="$HOME/logs/npm-maintenance.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1
exec 2>&1

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local level="$1"; shift; printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"; }

# ── Log truncation if file > 5MB ───────────────────────
LOG_MAX_MB=5
if [[ -f "$LOG_FILE" ]]; then
  size=$(du -m "$LOG_FILE" | cut -f1)
  if (( size > LOG_MAX_MB )); then
    log INFO "🧹 Truncating $LOG_FILE (was ${size}MB)"
    tail -n 200 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
  fi
fi

run_task() {
  log INFO "📦 Updating global npm packages..."
  npm update -g

  log INFO "🧹 Cleaning npm cache..."
  npm cache clean --force

  log INFO "ℹ️ Skipping npm audit (not supported for global packages)"

  log INFO "✅ npm maintenance complete."
}

if run_task; then
  osascript -e 'display notification "✅ npm maintenance complete." with title "npm update"'
  date +'%Y-%m-%d %H:%M:%S' > "$HOME/.cache/foundry/last-success-npm-maintenance-task.txt"
  exit 0
else
  osascript -e 'display notification "❌ npm maintenance failed!" with title "npm update" sound name "Funk"'
  exit 1
fi
