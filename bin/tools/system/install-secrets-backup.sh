#!/usr/bin/env bash
set -euo pipefail

# ── Setup log output ────────────────────────────────────────────
LOG_FILE="$HOME/logs/secrets-backup.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec >> "$LOG_FILE" 2>&1
exec 2>&1

# ── Check dependencies ──────────────────────────────────────────
command -v bw >/dev/null || {
  echo "[ERROR] bw CLI not found in PATH" >&2
  exit 1
}

# ── Helper functions ────────────────────────────────────────────
timestamp() {
  date +'%Y-%m-%d %H:%M:%S'
}

log() {
  local level="$1"
  shift
  printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"
}

run_secrets_backup_setup() {
  log INFO "🔐 Setting up Bitwarden secrets backup LaunchAgent..."

  local BACKUP_SCRIPT="$HOME/bin/tools/secrets/secrets-backup-task.sh"
  local PLIST_TEMPLATE="$HOME/bin/tools/system/secrets-backup.plist.template"
  local PLIST_DEST="$HOME/Library/LaunchAgents/com.user.secrets-backup.plist"
  local LOG_DIR="$HOME/logs"

  if [[ ! -f "$BACKUP_SCRIPT" || ! -f "$PLIST_TEMPLATE" ]]; then
    log WARN "⚠️  Missing script or template. Skipping secrets backup setup."
    return 0
  fi

  mkdir -p "$(dirname "$PLIST_DEST")"
  mkdir -p "$LOG_DIR"

  chmod +x "$BACKUP_SCRIPT"
  xattr -d com.apple.quarantine "$BACKUP_SCRIPT" 2>/dev/null || true

  export BACKUP_SCRIPT
  export LOG_DIR

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

if run_secrets_backup_setup; then
  osascript -e 'display notification "✅ Secrets backup installed." with title "LaunchAgent Setup"'
  log INFO "Script exited with code: 0"
  exit 0
else
  osascript -e 'display notification "❌ Secrets backup failed to install!" with title "LaunchAgent Setup" sound name "Funk"'
  log ERROR "Script failed with code: $?"
  exit 1
fi
