#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"
LOG_FILE="$HOME/logs/pipx-maintenance.log"
TOOLS_FILE="$HOME/.config/pipx/tools.txt"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1
exec 2>&1

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local level="$1"; shift; printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"; }

install_missing_tools() {
  log INFO "🔍 Checking for missing pipx tools..."
  while IFS= read -r line; do
    tool=$(echo "$line" | sed 's/#.*//' | xargs)
    [[ -z "$tool" ]] && continue

    if ! pipx list | grep -q "^package $tool "; then
      log INFO "📦 Installing missing tool: $tool"
      pipx install "$tool"
    fi
  done < "$TOOLS_FILE"
}

upgrade_tools() {
  log INFO "📈 Upgrading all pipx packages..."
  pipx upgrade-all
}

run_task() {
  install_missing_tools
  upgrade_tools
  log INFO "✅ pipx maintenance complete."
}

if run_task; then
  osascript -e 'display notification "✅ pipx maintenance complete." with title "pipx upgrade"'
  date +'%Y-%m-%d %H:%M:%S' > "$HOME/.cache/foundry/last-success-pipx-maintenance.txt"
  exit 0
else
  osascript -e 'display notification "❌ pipx maintenance failed!" with title "pipx upgrade" sound name "Funk"'
  exit 1
fi
