#!/usr/bin/env bash
set -euo pipefail

# Ensure Homebrew is available
# shellcheck source=/dev/null
source "$HOME/bin/foundry/ensure-brew-path.sh"

LOG_FILE="$HOME/logs/setup-python-env.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local lvl="$1"; shift; printf "[%s] %s %s\n" "$lvl" "$(timestamp)" "$*"; }

log INFO "🐍 Starting Python environment setup..."

# ── Read versions from file ──────────────────────────────
VERSIONS_FILE="$HOME/.config/python/versions.txt"
PY_VERSIONS=()
while IFS= read -r line; do
  ver="$(echo "$line" | sed 's/#.*//' | xargs)"
  [[ -n "$ver" ]] && PY_VERSIONS+=("$ver")
done < "$VERSIONS_FILE"

# ── Install versions if missing ──────────────────────────
for ver in "${PY_VERSIONS[@]}"; do
  if ! pyenv versions --bare | grep -qx "$ver"; then
    log INFO "⬇️  Installing Python $ver..."
    pyenv install --skip-existing "$ver"
  else
    log INFO "✅ Python $ver already installed"
  fi
done

# ── Set global version to match list ─────────────────────
log INFO "🌍 Setting global Python version: ${PY_VERSIONS[*]}"
pyenv global "${PY_VERSIONS[@]}" system

# ── Poetry setup ─────────────────────────────────────────
if [[ "${SKIP_POETRY:-false}" != "true" ]]; then
  if ! command -v poetry >/dev/null; then
    log INFO "🎼 Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
  else
    log INFO "✅ Poetry already installed"
  fi
else
  log INFO "⏭️  Skipping Poetry install (SKIP_POETRY=true)"
fi

# ── pip-tools setup ──────────────────────────────────────
if [[ "${SKIP_PIP_TOOLS:-false}" != "true" ]]; then
  if ! pipx list | grep -q 'package pip-tools '; then
    log INFO "🧰 Installing pip-tools via pipx..."
    pipx install pip-tools
  else
    log INFO "✅ pip-tools already installed"
  fi
else
  log INFO "⏭️  Skipping pip-tools install (SKIP_PIP_TOOLS=true)"
fi

# ── Ensure ~/.local/bin is in PATH immediately ───────────
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
  log INFO "📌 Temporarily added ~/.local/bin to PATH"
  hash -r
fi

log INFO "✅ Python environment setup complete."

# Only show macOS notification if osascript is available
if command -v osascript &>/dev/null; then
  osascript -e 'display notification "✅ Python + Poetry/pip-tools ready." with title "Foundry Setup"'
fi
