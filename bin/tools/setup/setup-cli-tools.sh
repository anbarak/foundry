#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Setting up CLI tools (pipx/npm)..."

# ---------------------
# pipx tools
# ---------------------
if command -v pipx &>/dev/null; then
  echo "📦 Installing pipx CLI tools..."

  # If manifest file exists, restore from it
  if [ -f "$HOME/.config/pipx/tools.txt" ]; then
    echo "📄 Restoring tools from ~/.config/pipx/tools.txt..."
    grep -v '^\s*#' "$HOME/.config/pipx/tools.txt" \
      | sed 's/#.*//' \
      | awk '{print $1}' \
      | xargs -n 1 pipx install || true
  else
    echo "⚠️  pipx tools.txt not found — skipping pipx installs"
  fi
else
  echo "⚠️ pipx not found — skipping pipx installs"
fi

# ---------------------
# npm tools
# ---------------------
if command -v npm >/dev/null 2>&1 && [ -f "$HOME/.config/npm/global-packages.txt" ]; then
  echo "📦 Installing npm global tools..."
  xargs -n 1 npm install -g < "$HOME/.config/npm/global-packages.txt"
else
  echo "⚠️  npm or global-packages.txt not found — skipping npm installs"
fi
