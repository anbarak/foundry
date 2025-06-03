#!/bin/zsh
set -euo pipefail

# ── Setup log output ────────────────────────────────────────────
LOG_FILE="$HOME/logs/restart-reminder.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec >> "$LOG_FILE" 2>&1
exec 2>&1

# ── Helper functions ────────────────────────────────────────────
timestamp() {
  date +'%Y-%m-%d %H:%M:%S'
}

log() {
  local level="$1"
  shift
  printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"
}

run_restart_reminder_setup() {
  log INFO "🔧 Installing restart reminder LaunchAgent..."

  local RESTART_SCRIPT="$HOME/bin/tools/system/restart-reminder-task.sh"
  local PLIST_TEMPLATE="$HOME/bin/tools/system/restart-reminder.plist.template"
  local PLIST_DEST="$HOME/Library/LaunchAgents/com.user.restart-reminder.plist"

  mkdir -p "$(dirname "$PLIST_DEST")"
  mkdir -p "$HOME/logs"

  chmod +x "$RESTART_SCRIPT"
  xattr -d com.apple.quarantine "$RESTART_SCRIPT" 2>/dev/null || true

  export RESTART_SCRIPT
  export LOG_DIR="$HOME/logs"

  envsubst < "$PLIST_TEMPLATE" > "$PLIST_DEST"

  launchctl unload "$PLIST_DEST" 2>/dev/null || true
  sleep 1
  if launchctl load "$PLIST_DEST"; then
    log INFO "✅ LaunchAgent reloaded successfully: $PLIST_DEST"
    return 0
  else
    log ERROR "❌ Failed to reload LaunchAgent: $PLIST_DEST"
    return 1
  fi
}

if run_restart_reminder_setup; then
  osascript -e 'display notification "✅ Restart reminder installed." with title "LaunchAgent Setup"'
  log INFO "Script exited with code: 0"
  exit 0
else
  osascript -e 'display notification "❌ Restart reminder failed to install!" with title "LaunchAgent Setup" sound name "Funk"'
  log ERROR "Script failed with code: $?"
  exit 1
fi
