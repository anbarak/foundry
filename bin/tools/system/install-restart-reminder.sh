#!/bin/zsh

set -euo pipefail

PLIST_SRC="$HOME/bin/tools/system/restart-reminder.plist.template"
PLIST_DEST="$HOME/Library/LaunchAgents/com.user.restartreminder.plist"

# Generate LaunchAgent plist with correct paths
echo "🔧 Installing restart reminder plist..."
envsubst < "$PLIST_SRC" > "$PLIST_DEST"

# Load the plist via launchctl
launchctl unload "$PLIST_DEST" 2>/dev/null || true
launchctl load "$PLIST_DEST"

echo "✅ Weekly restart reminder installed: runs every Monday @ 8 AM"
