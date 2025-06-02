#!/usr/bin/env bash
set -euo pipefail

echo "🔐 Setting up Bitwarden secrets backup LaunchAgent..."

# Define paths
BACKUP_SCRIPT="$HOME/bin/tools/secrets/backup"
PLIST_TEMPLATE="$HOME/bin/tools/system/secrets-backup.plist.template"
PLIST_DEST="$HOME/Library/LaunchAgents/com.user.secrets-backup.plist"
LOG_DIR="$HOME/logs"

# Validate input files
if [[ ! -f "$BACKUP_SCRIPT" || ! -f "$PLIST_TEMPLATE" ]]; then
  echo "⚠️  Missing script or template. Skipping secrets backup setup."
  exit 0
fi

# Ensure directories exist
mkdir -p "$(dirname "$PLIST_DEST")"
mkdir -p "$LOG_DIR"

# Strip macOS quarantine to avoid unidentified developer warnings
chmod +x "$BACKUP_SCRIPT"
xattr -d com.apple.quarantine "$BACKUP_SCRIPT" 2>/dev/null || true

# Export vars for envsubst
export BACKUP_SCRIPT LOG_DIR

# Generate and install plist
envsubst < "$PLIST_TEMPLATE" > "$PLIST_DEST"

# Reload the job
launchctl unload "$PLIST_DEST" 2>/dev/null || true
launchctl load "$PLIST_DEST"

echo "✅ LaunchAgent installed: $PLIST_DEST"
