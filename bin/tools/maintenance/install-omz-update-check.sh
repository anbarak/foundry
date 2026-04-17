#!/usr/bin/env bash
set -euo pipefail

# ── Setup log output ────────────────────────────────────────────
LOG_FILE="$HOME/logs/omz-update-check.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local level="$1"; shift; printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"; }

log INFO "🔧 Installing Oh My Zsh update-check LaunchAgent..."

# ── Variables ───────────────────────────────────────────────────
SCRIPT="$HOME/bin/tools/maintenance/omz-update-check-task.sh"
PLIST_TEMPLATE="$HOME/bin/tools/maintenance/omz-update-check.plist.template"
PLIST_DEST="$HOME/Library/LaunchAgents/com.user.omz-update-check.plist"
LOG_DIR="$HOME/logs"

# ── Ensure permissions ──────────────────────────────────────────
mkdir -p "$(dirname "$PLIST_DEST")"
chmod +x "$SCRIPT"
xattr -d com.apple.quarantine "$SCRIPT" 2>/dev/null || true

# ── Render and load plist ───────────────────────────────────────
export SCRIPT LOG_DIR
envsubst < "$PLIST_TEMPLATE" > "$PLIST_DEST"

launchctl unload "$PLIST_DEST" 2>/dev/null || true
sleep 1

if launchctl load "$PLIST_DEST"; then
  log INFO "✅ LaunchAgent loaded: $PLIST_DEST"
else
  log ERROR "❌ Failed to load LaunchAgent: $PLIST_DEST"
  osascript -e 'display notification "❌ Failed to install OMZ update-check LaunchAgent!" with title "LaunchAgent Setup" sound name "Funk"'
  exit 1
fi

# ── Optionally run task immediately to verify ───────────────────
if "$SCRIPT"; then
  osascript -e 'display notification "✅ OMZ update-check installed and tested." with title "LaunchAgent Setup"'
  log INFO "Script exited with code: 0"
else
  osascript -e 'display notification "❌ Task script failed during setup." with title "LaunchAgent Setup" sound name "Funk"'
  log ERROR "Script failed with code: $?"
  exit 1
fi
