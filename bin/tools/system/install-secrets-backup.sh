#!/usr/bin/env bash
set -euo pipefail
umask 077

# Keep PATH sane when run from non-interactive contexts
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

# ── Setup log output ────────────────────────────────────────────
LOG_FILE="$HOME/logs/secrets-backup.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec >> "$LOG_FILE" 2>&1

# ── Check dependencies ──────────────────────────────────────────
command -v bw >/dev/null || {
  echo "[ERROR] bw CLI not found in PATH" >&2
  exit 1
}
command -v envsubst >/dev/null || {
  echo "[ERROR] envsubst (gettext) not found in PATH"
  exit 1
}

# ── Helpers ─────────────────────────────────────────────────────
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

  # LaunchAgent label/target
  local LABEL="com.user.secrets-backup"
  local AGENT_TARGET="gui/$UID/$LABEL"

  # Stop existing (best-effort) using modern API, fall back if needed
  if launchctl print "$AGENT_TARGET" >/dev/null 2>&1; then
    launchctl bootout "gui/$UID" "$PLIST_DEST" 2>/dev/null || true
  else
    launchctl unload "$PLIST_DEST" 2>/dev/null || true
  fi

  # Start (modern first, fall back)
  if launchctl bootstrap "gui/$UID" "$PLIST_DEST" 2>/dev/null; then
    :
  else
    launchctl load "$PLIST_DEST"
  fi

  # Ensure enabled and fire once now
  launchctl enable "$AGENT_TARGET" 2>/dev/null || true
  launchctl kickstart -k "$AGENT_TARGET"

  log INFO "✅ LaunchAgent installed and started: $PLIST_DEST"

  # Optional: auto-wake before Monday 10:00 (requires sudo)
  # Opt in by: export CF_ENABLE_BACKUP_WAKE=1
  # Customize time via: export CF_BACKUP_WAKE_TIME="09:58:00"
  if [[ "${CF_ENABLE_BACKUP_WAKE:-0}" == "1" ]]; then
    local WAKE_TIME="${CF_BACKUP_WAKE_TIME:-09:58:00}"
    log INFO "⏰ Configuring auto-wake for Mondays at $WAKE_TIME"
    sudo pmset repeat wakeorpoweron M "$WAKE_TIME" || log WARN "⚠️  pmset failed; skipping auto-wake"
  fi

  return 0
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
