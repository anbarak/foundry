#!/usr/bin/env bash
set -euo pipefail

echo "📦 Starting Homebrew maintenance ($(date))..."

brew update
brew upgrade
brew cleanup -s
brew doctor || true
brew outdated || true

# Refresh Brewfile to lock current state
BREWFILE="$HOME/.config/homebrew/Brewfile"
if [[ -f "$BREWFILE" ]]; then
  brew bundle dump --file="$BREWFILE" --force
  echo "✅ Brewfile updated."
fi

cd ~/.config/homebrew
git add Brewfile
git commit -m "🔄 Weekly Homebrew maintenance ($(date +%F))"
git push

echo "✅ Homebrew maintenance complete."

# -----------------------------------------------------------------------------
# Setup Homebrew maintenance job in launchd (runs weekly on Mondays)
# -----------------------------------------------------------------------------
echo "🕑 Setting up launchd job for weekly Homebrew maintenance..."

BREW_SCRIPT="$HOME/bin/tools/system/maintain-homebrew.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.user.brew-maintenance.plist"
PLIST_TEMPLATE="$HOME/bin/tools/system/brew-maintenance.plist.template"

mkdir -p "$(dirname "$PLIST_PATH")"
sed "s|{{BREW_SCRIPT}}|$BREW_SCRIPT|" "$PLIST_TEMPLATE" > "$PLIST_PATH"

launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo "✅ launchd job installed: $PLIST_PATH"
