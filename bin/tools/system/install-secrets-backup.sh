#!/usr/bin/env bash
set -euo pipefail

echo "🔐 Setting up Bitwarden secrets backup LaunchAgent..."

BACKUP_SCRIPT="$HOME/bin/tools/secrets/backup"
PLIST_PATH="$HOME/Library/LaunchAgents/com.user.secrets-backup.plist"
PLIST_TEMPLATE="$HOME/bin/tools/system/secrets-backup.plist.template"

if [[ -f "$BACKUP_SCRIPT" && -f "$PLIST_TEMPLATE" ]]; then
  mkdir -p "$(dirname "$PLIST_PATH")"
  sed "s|{{BACKUP_SCRIPT}}|$BACKUP_SCRIPT|" "$PLIST_TEMPLATE" > "$PLIST_PATH"

  launchctl unload "$PLIST_PATH" 2>/dev/null || true
  launchctl load "$PLIST_PATH"

  echo "✅ LaunchAgent installed: $PLIST_PATH"
else
  echo "⚠️  Missing script or template. Skipping secrets backup setup."
fi
