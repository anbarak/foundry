#!/usr/bin/env bash
set -euo pipefail

# Setup log output
LOG_FILE="$HOME/logs/homebrew_maintenance.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "[INFO] $(date +'%Y-%m-%d %H:%M:%S') Starting Homebrew maintenance..."

run_maintenance() {
  echo "📦 Running brew update & upgrade..."
  brew update
  brew upgrade

  echo "🧹 Cleaning up unused packages..."
  brew cleanup -s

  echo "🩺 Checking system health..."
  brew doctor || true
  brew outdated || true

  # Refresh Brewfile to lock current state
  BREWFILE="$HOME/.config/homebrew/Brewfile"
  if [[ -f "$BREWFILE" ]]; then
    brew bundle dump --file="$BREWFILE" --force
    echo "✅ Brewfile updated."

    yadm add "$BREWFILE"
    if yadm diff --cached --quiet "$BREWFILE"; then
      echo "ℹ️  No changes to Brewfile. Skipping commit."
    else
      yadm commit -m "🔄 Weekly Homebrew maintenance ($(date +%F))"
      yadm push
    fi
  fi

  echo "✅ Homebrew maintenance complete."

  # Setup Homebrew maintenance launchd job (every Monday)
  echo "🕑 Setting up launchd job for weekly Homebrew maintenance..."

  BREW_SCRIPT="$HOME/bin/tools/system/maintain-homebrew.sh"
  PLIST_TEMPLATE="$HOME/bin/tools/system/brew-maintenance.plist.template"
  PLIST_DEST="$HOME/Library/LaunchAgents/com.user.brew-maintenance.plist"

  mkdir -p "$(dirname "$PLIST_DEST")"

  chmod +x "$BREW_SCRIPT"
  xattr -d com.apple.quarantine "$BREW_SCRIPT" 2>/dev/null || true

  export BREW_SCRIPT LOG_DIR="$(dirname "$LOG_FILE")"

  envsubst < "$PLIST_TEMPLATE" > "$PLIST_DEST"
  launchctl unload "$PLIST_DEST" 2>/dev/null || true
  launchctl load "$PLIST_DEST"

  echo "✅ LaunchAgent installed: $PLIST_DEST"
}

# Run with error handling and macOS notification
if run_maintenance; then
  osascript -e 'display notification "✅ Homebrew maintenance complete." with title "brew update & cleanup"'
  echo "[INFO] $(date +'%Y-%m-%d %H:%M:%S') Script exited with code: 0"
  exit 0
else
  osascript -e 'display notification "❌ Homebrew maintenance failed!" with title "brew update & cleanup" sound name "Funk"'
  echo "[ERROR] $(date +'%Y-%m-%d %H:%M:%S') Script failed with code: $?"
  exit 1
fi
