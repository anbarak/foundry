#!/usr/bin/env bash
set -euo pipefail

# ── Setup log output ────────────────────────────────────────────
LOG_FILE="$HOME/logs/omz-update-check-task.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local level="$1"; shift; printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"; }

log INFO "🔍 Checking for Oh My Zsh updates..."

OMZ_DIR="$HOME/.oh-my-zsh"

# Guard: only run if OMZ is a git checkout
if [[ ! -d "$OMZ_DIR/.git" ]]; then
  log WARN "Oh My Zsh directory is not a git checkout — skipping"
  exit 0
fi

cd "$OMZ_DIR"

# Fetch latest refs from upstream
if ! git fetch origin master >/dev/null 2>&1; then
  log ERROR "git fetch failed — are you offline?"
  exit 0  # don't fail the launchd job on transient network issues
fi

LOCAL=$(git rev-parse HEAD 2>/dev/null || echo "")
REMOTE=$(git rev-parse origin/master 2>/dev/null || echo "")

if [[ -z "$LOCAL" || -z "$REMOTE" ]]; then
  log ERROR "Could not resolve local/remote SHAs"
  exit 1
fi

if [[ "$LOCAL" == "$REMOTE" ]]; then
  log INFO "✅ Oh My Zsh is up to date (HEAD: ${LOCAL:0:7})"
  exit 0
fi

# Count how many commits behind
BEHIND=$(git rev-list --count "${LOCAL}..${REMOTE}" 2>/dev/null || echo "?")

log INFO "📦 Oh My Zsh is $BEHIND commits behind (local: ${LOCAL:0:7}, remote: ${REMOTE:0:7})"

osascript -e "display notification \"$BEHIND commits behind. Run: omz update\" with title \"Oh My Zsh update available\""
