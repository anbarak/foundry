#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="$HOME/logs/pipx-maintenance.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local level="$1"; shift; printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"; }

log INFO "🔧 Installing pipx maintenance LaunchAgent..."

SCRIPT="$HOME/bin/tools/maintenance/pipx-maintenance-task.sh"
PLIST_TEMPLATE="$HOME/bin/tools/maintenance/pipx-maintenance.plist.template"
PLIST_DEST="$HOME/Library/LaunchAgents/com.user.pipx-maintenance.plist"
LOG_DIR="$HOME/logs"

chmod +x "$SCRIPT"
xattr -d com.apple.quarantine "$SCRIPT" 2>/dev/null || true

export SCRIPT LOG_DIR
envsubst < "$PLIST_TEMPLATE" > "$PLIST_DEST"

launchctl unload "$PLIST_DEST" 2>/dev/null || true
sleep 1
launchctl load "$PLIST_DEST" && log INFO "✅ Loaded: $PLIST_DEST"

"$SCRIPT"
