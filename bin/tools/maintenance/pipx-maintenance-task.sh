#!/usr/bin/env bash
set -euo pipefail

# --- Ensure PATH works under launchd and interactive shells ---
# Order matters: prefer Homebrew, then user-local, then system.
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

LOG_FILE="$HOME/logs/pipx-maintenance.log"
TOOLS_FILE="$HOME/.config/pipx/tools.txt"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local level="$1"; shift; printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"; }

# ── Log truncation if file > 5MB ───────────────────────
LOG_MAX_MB=5
if [[ -f "$LOG_FILE" ]]; then
  size=$(du -m "$LOG_FILE" | cut -f1)
  if (( size > LOG_MAX_MB )); then
    log INFO "🧹 Truncating $LOG_FILE (was ${size}MB)"
    tail -n 200 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
  fi
fi

ensure_pipx() {
  if command -v pipx >/dev/null 2>&1; then
    return
  fi

  log INFO "🔧 pipx not found. Attempting bootstrap…"

  # Try Homebrew first (common on macOS ARM at /opt/homebrew)
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    /opt/homebrew/bin/brew install pipx || true
  elif command -v brew >/dev/null 2>&1; then
    brew install pipx || true
  fi

  # If still missing, fallback to user install via pip
  if ! command -v pipx >/dev/null 2>&1; then
    if command -v python3 >/dev/null 2>&1; then
      python3 -m pip install --user pipx || true
    fi
  fi

  # Make sure ~/.local/bin is on PATH for future shells
  if command -v pipx >/dev/null 2>&1; then
    pipx ensurepath >/dev/null 2>&1 || true
  else
    log ERROR "🛑 Could not bootstrap pipx. Check Python/Homebrew installation."
    exit 1
  fi
}

safe_pipx_install() {
  local tool="$1"

  if pipx list | grep -q "^package $tool "; then
    log INFO "✅ $tool already installed. Skipping."
    return
  fi

  log INFO "📦 Installing missing tool: $tool"

  if [[ "$tool" == "aider-chat" ]]; then
    log INFO "🐍 Precreating aider-chat venv and injecting numpy to avoid build issues"
    pipx install --python "$(pyenv which python3)" --no-cache --suffix -bootstrap virtualenv || true
    pipx runpip aider-chat-bootstrap install numpy==1.24.3 || true
    pipx uninstall aider-chat-bootstrap || true
  fi

  if ! pipx install "$tool"; then
    log WARN "❌ $tool failed. Retrying without isolated build..."
    if ! PIP_NO_ISOLATED_BUILD=1 pipx install "$tool"; then
      log ERROR "🛑 $tool install failed again. See pipx logs for details."
    fi
  fi
}

install_missing_tools() {
  log INFO "🔍 Checking for missing pipx tools..."
  while IFS= read -r line; do
    tool=$(echo "$line" | sed 's/#.*//' | xargs)
    [[ -z "$tool" ]] && continue
    safe_pipx_install "$tool"
  done < "$TOOLS_FILE"
}

upgrade_tools() {
  log INFO "📈 Upgrading all pipx packages..."
  pipx upgrade-all
}

run_task() {
  ensure_pipx
  install_missing_tools
  upgrade_tools
  log INFO "✅ pipx maintenance complete."
}

if run_task; then
  osascript -e 'display notification "✅ pipx maintenance complete." with title "pipx upgrade"'
  date +'%Y-%m-%d %H:%M:%S' > "$HOME/.cache/foundry/last-success-pipx-maintenance-task.txt"
  exit 0
else
  osascript -e 'display notification "❌ pipx maintenance failed!" with title "pipx upgrade" sound name "Funk"'
  exit 1
fi
