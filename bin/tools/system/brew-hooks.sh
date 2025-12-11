#!/usr/bin/env bash
# Brew post-command hook - Auto-update and commit Brewfile
# Location: ~/bin/tools/system/brew-hooks.sh

set -euo pipefail

# Only process install/upgrade/uninstall commands
if [[ "$HOMEBREW_COMMAND" =~ ^(install|upgrade|uninstall)$ ]]; then
  brewfile="$HOME/.config/homebrew/Brewfile"
  
  # Update Brewfile
  brew bundle dump --file="$brewfile" --force 2>/dev/null || {
    echo "⚠️  Failed to dump Brewfile" >&2
    exit 0
  }
  
  # Check if Brewfile changed
  if ! yadm diff --quiet "$brewfile" 2>/dev/null; then
    # Stage and commit Brewfile
    yadm add "$brewfile" 2>/dev/null || exit 0
    
    if yadm commit -m "📦 Brewfile: ${HOMEBREW_COMMAND} ${HOMEBREW_COMMAND_ARGS[*]}" --no-gpg-sign 2>/dev/null; then
      # Push in background to not block
      (yadm push 2>/dev/null &)
      echo "✅ Brewfile committed and pushing..."
    fi
  fi
fi
