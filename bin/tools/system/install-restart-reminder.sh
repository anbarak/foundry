#!/bin/zsh
set -euo pipefail

PLIST_TEMPLATE="$HOME/bin/tools/system/restart-reminder.plist.template"
PLIST_DEST="$HOME/Library/LaunchAgents/com.user.restartreminder.plist"

# Expand environment vars in template
export RESTART_SCRIPT="$HOME/bin/tools/system/restart-prep.sh"
export LOG_DIR="$HOME/logs"
mkdir -p "$LOG_DIR"

# Replace placeholders in template and write to final plist
echo "🔧 Installing restart reminder LaunchAgent..."
envsubst < "$PLIST_TEMPLATE" > "$PLIST_DEST"

# Make script executable and remove quarantine
chmod +x "$RESTART_SCRIPT"
xattr -d com.apple.quarantine "$RESTART_SCRIPT" 2>/dev/null || true

# Load LaunchAgent
launchctl unload "$PLIST_DEST" 2>/dev/null || true
launchctl load "$PLIST_DEST"

echo "✅ Restart reminder LaunchAgent installed: runs every Monday @ 8 AM"
