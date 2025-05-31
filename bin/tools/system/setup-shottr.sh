#!/usr/bin/env bash

set -euo pipefail

echo "🔧 Setting up Shottr..."

# Define paths
CONFIG_SRC="$HOME/.config/shottr/cc.ffitch.shottr.plist"
CONFIG_DEST="$HOME/Library/Containers/cc.ffitch.shottr/Data/Library/Preferences/cc.ffitch.shottr.plist"

# Install Shottr if not already installed
if ! brew list --cask shottr &>/dev/null; then
  echo "📦 Installing Shottr..."
  brew install --cask shottr
else
  echo "✅ Shottr already installed."
fi

# Ensure Shottr has been launched at least once
if [[ ! -d "$HOME/Library/Containers/cc.ffitch.shottr" ]]; then
  echo "⚠️ Shottr has never been launched. Please launch it once manually, then rerun this script."
  exit 1
fi

# Restore saved preferences if they exist
if [[ -f "$CONFIG_SRC" ]]; then
  echo "♻️ Restoring Shottr preferences..."
  mkdir -p "$(dirname "$CONFIG_DEST")"
  cp "$CONFIG_SRC" "$CONFIG_DEST"
  killall cfprefsd &>/dev/null || true
  echo "✅ Preferences restored."
else
  echo "⚠️ No saved Shottr preferences found at:"
  echo "   $CONFIG_SRC"
  echo "📖 If you want to set up Shottr manually, see:"
  echo "   ~/.config/shottr/shottr-config.md"
fi

echo "✅ Shottr setup complete."
