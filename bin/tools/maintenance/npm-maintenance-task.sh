#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="$HOME/logs/npm-maintenance.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1
exec 2>&1

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local level="$1"; shift; printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"; }

run_task() {
  log INFO "📦 Updating global npm packages..."
  npm update -g

  log INFO "🧹 Cleaning npm cache..."
  npm cache clean --force

  log INFO "🔍 Running npm audit..."
  npm audit --global || true

  log INFO "✅ npm maintenance complete."
}

if run_task; then
  osascript -e 'display notification "✅ npm maintenance complete." with title "npm update"'
  date +'%Y-%m-%d %H:%M:%S' > "$HOME/.cache/foundry/last-success-npm-maintenance.txt"
  exit 0
else
  osascript -e 'display notification "❌ npm maintenance failed!" with title "npm update" sound name "Funk"'
  exit 1
fi
