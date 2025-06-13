#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

LOG_FILE="$HOME/logs/brew-maintenance.log"
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

run_maintenance() {
  log INFO "📦 Running brew update & upgrade..."
  brew update
  brew upgrade

  log INFO "🧹 Cleaning up unused packages..."
  brew cleanup -s

  log INFO "🩺 Checking system health..."
  brew doctor || true
  brew outdated || true

  BREWFILE="$HOME/.config/homebrew/Brewfile"
  if [[ -f "$BREWFILE" ]]; then
    brew bundle dump --file="$BREWFILE" --force 2> >(grep -v "Their taps are in use" >&2)
    log INFO "✅ Brewfile updated."

    yadm add "$BREWFILE"
    if yadm diff --cached --quiet "$BREWFILE"; then
      log INFO "ℹ️  No changes to Brewfile. Skipping commit."
    else
      yadm commit -m "🔄 Weekly Homebrew maintenance ($(date +%F))"
      yadm push
    fi
  fi

  log INFO "✅ Homebrew maintenance complete."
}

if run_maintenance; then
  osascript -e 'display notification "✅ Homebrew maintenance complete." with title "brew update & cleanup"'

  # 📝 Record last successful run
  LABEL="$(basename "$0" .sh)"
  mkdir -p "$HOME/.cache/foundry"
  date +'%Y-%m-%d %H:%M:%S' > "$HOME/.cache/foundry/last-success-${LABEL}.txt"

  exit 0
else
  osascript -e 'display notification "❌ Homebrew maintenance failed!" with title "brew update & cleanup" sound name "Funk"'
  exit 1
fi
