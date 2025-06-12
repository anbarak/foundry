#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="$HOME/logs/setup-python-env.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local lvl="$1"; shift; printf "[%s] %s %s\n" "$lvl" "$(timestamp)" "$*"; }

log INFO "🐍 Starting Python environment setup..."

# ── Install pyenv and prerequisites ──────────────────────
brew install pyenv openssl readline sqlite3 xz zlib

# ── Ensure pyenv is in ZSH config ────────────────────────
ZSH_PROFILE="$HOME/.config/zsh/modules/06-cloud.zsh"
if ! grep -q 'pyenv init' "$ZSH_PROFILE"; then
  log INFO "➕ Adding pyenv config to ZSH..."
  {
    echo ''
    echo '# pyenv setup'
    echo 'export PYENV_ROOT="$HOME/.pyenv"'
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
    echo 'eval "$(pyenv init --path)"'
    echo 'eval "$(pyenv init -)"'
  } >> "$ZSH_PROFILE"
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

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
    pyenv install "$ver"
  else
    log INFO "✅ Python $ver already installed"
  fi
done

log INFO "🌍 Setting global Python version: ${PY_VERSIONS[*]}"
pyenv global "${PY_VERSIONS[@]}" system

# ── Poetry setup ─────────────────────────────────────────
if [[ "${SKIP_POETRY:-false}" != "true" ]]; then
  if ! command -v poetry >/dev/null; then
    log INFO "🎼 Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
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

log INFO "✅ Python environment setup complete."
osascript -e 'display notification "✅ Python + Poetry/pip-tools ready." with title "Foundry Setup"'
