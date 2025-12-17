#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

LOG_FILE="$HOME/logs/brew-maintenance.log"
mkdir -p "$(dirname "$LOG_FILE")"

# If interactive → tee. If running under launchd → append only (avoid double logs
# because launchd already captures stdout/stderr via StandardOutPath).
if [[ -t 1 ]]; then
  exec > >(tee -a "$LOG_FILE") 2>&1
else
  exec >>"$LOG_FILE" 2>&1
fi

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local level="$1"; shift; printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*"; }

# ── Concurrency lock (avoid overlapping runs) ────────────────────────────────
LOCK_DIR="$HOME/.cache/foundry/locks"
LOCK="$LOCK_DIR/$(basename "$0").lock"
mkdir -p "$LOCK_DIR"

if ! mkdir "$LOCK" 2>/dev/null; then
  log WARN "Another run is in progress; exiting."
  exit 0
fi
trap 'rmdir "$LOCK" 2>/dev/null || true' EXIT

# ── Log truncation if file > 5MB ───────────────────────
LOG_MAX_MB=5
if [[ -f "$LOG_FILE" ]]; then
  size=$(du -m "$LOG_FILE" | cut -f1)
  if (( size > LOG_MAX_MB )); then
    log INFO "🧹 Truncating $LOG_FILE (was ${size}MB)"
    tail -n 200 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
  fi
fi

quit_app_if_running() {
  local app_name="$1"
  if osascript -e "application \"$app_name\" is running" 2>/dev/null | grep -q true; then
    log INFO "🛑 Quitting $app_name before upgrade..."
    osascript -e "quit app \"$app_name\"" || true
    sleep 2
  fi
}

is_interactive() { [[ -t 1 ]]; }

get_skipped_items() {
  local out_var="$1"
  local skipped_items=()

  # Fallback: avoid using mapfile
  while IFS= read -r cask; do
    [[ -z "$cask" ]] && continue

    local json app_path full_path caskroom_path
    if ! json=$(brew info --cask --json=v2 "$cask" 2>/dev/null); then
      continue
    fi

    caskroom_path="/opt/homebrew/Caskroom/$cask"
    local needs_privilege=false

    # Heuristic 1
    if jq -e '
      .casks[0] |
      .uninstall or
      .installer or
      (.artifacts[]? | select(type == "object" and (has("pkg") or has("installer") or has("uninstall")))
    )' <<<"$json" >/dev/null; then
      needs_privilege=true
    fi

    # Heuristic 2
    while IFS= read -r app_path; do
      full_path="/Applications/$app_path"
      if [[ -e "$full_path" && ! -w "$full_path" ]]; then
        needs_privilege=true
        break
      fi
    done < <(jq -r '.casks[0].app[]?' <<<"$json")

    # Heuristic 3
    if [[ -d "$caskroom_path" && ! -w "$caskroom_path" ]]; then
      needs_privilege=true
    fi

    if [[ "$needs_privilege" == true ]]; then
      skipped_items+=("cask:$cask")
    fi
  done < <(brew outdated --cask --greedy | grep -v '^\s*$')

  # Export result via indirect reference
  if (( ${#skipped_items[@]:-0} > 0 )); then
    eval "$out_var=(\"\${skipped_items[@]}\")"
  else
    eval "$out_var=()"
  fi
}

run_maintenance() {
  local -a skipped=()
  get_skipped_items skipped

  log INFO "📦 Running brew update & upgrade..."
  brew update

  # Upgrade all formulae except those needing sudo
  outdated_formulas=()
  if brew outdated --formula | grep -q .; then
    while IFS= read -r f; do
      [[ -n "$f" ]] && outdated_formulas+=("$f")
    done < <(brew outdated --formula)
  fi

  if (( ${#outdated_formulas[@]:-0} > 0 )); then
    for formula in "${outdated_formulas[@]}"; do
      log INFO "⬆️  Upgrading $formula..."
      brew upgrade "$formula"
    done
  fi

  # Upgrade casks:
  # - launchd mode: conservative (no sudo prompts)
  # - interactive mode: greedy (will prompt for sudo)
  if is_interactive; then
    log INFO "Interactive mode: upgrading casks with --greedy (may prompt for sudo)..."
    sudo -v
    brew upgrade --cask --greedy || true
  else
    log INFO "Launchd mode: upgrading casks without --greedy (no sudo prompts)..."

    # Keep your existing skip logic for sudo-required casks
    outdated_casks=()
    if brew outdated --cask | grep -q .; then
      while IFS= read -r c; do
        [[ -n "$c" ]] && outdated_casks+=("$c")
      done < <(brew outdated --cask)
    fi

    if (( ${#outdated_casks[@]:-0} > 0 )); then
      for cask in "${outdated_casks[@]}"; do
        if printf '%s\n' "${skipped[@]}" | grep -q "cask:$cask"; then
          log INFO "⏭️  Skipping $cask (requires sudo)"
          continue
        fi

        log INFO "⬆️  Upgrading cask: $cask..."
        app_name=$(brew info --cask --json=v2 "$cask" | jq -r '.casks[0].app[0]' 2>/dev/null || echo "")
        if [[ -n "$app_name" ]]; then
          quit_app_if_running "$app_name"
        fi

        brew upgrade --cask "$cask" || true
      done
    fi
  fi

  log INFO "🧹 Cleaning up unused packages..."
  brew cleanup -s

  log INFO "🩺 Checking system health..."
  brew doctor || true
  brew outdated || true

  BREWFILE="$HOME/.config/homebrew/Brewfile"
  if [[ -f "$BREWFILE" ]]; then
    # Ensure node is linked before dumping Brewfile
    if brew list node &>/dev/null && ! brew list --formula node &>/dev/null; then
      brew link node --overwrite --force || true
    fi

    brew bundle dump --file="$BREWFILE" --force 2> >(grep -v "Their taps are in use" >&2)

    # Sanitize link: false (node)
    sed -i '' 's/brew "node", link: false/brew "node"/' "$BREWFILE"

    log INFO "✅ Brewfile updated."

    yadm add "$BREWFILE"
    if yadm diff --cached --quiet "$BREWFILE"; then
      log INFO "ℹ️  No changes to Brewfile. Skipping commit."
    else
      yadm commit -m "🔄 Weekly Homebrew maintenance ($(date +%F))"
      yadm push
    fi
  fi

  if (( ${#skipped[@]} )); then
    log INFO "⚠️ Skipped items that require manual upgrade:"
    for item in "${skipped[@]}"; do
      echo "  - ${item#cask:} (cask)"
    done
  fi

  log INFO "✅ Homebrew maintenance complete."
}

if run_maintenance; then
  osascript -e 'display notification "✅ Homebrew maintenance complete." with title "brew update & cleanup"'

  # 📝 Record last successful run
  LABEL="$(basename "$0" .sh)"
  mkdir -p "$HOME/.cache/foundry"
  date +'%Y-%m-%d %H:%M:%S' > "$HOME/.cache/foundry/last-success-${LABEL}.txt"

  exit 0
else
  osascript -e 'display notification "❌ Homebrew maintenance failed!" with title "brew update & cleanup" sound name "Funk"'
  exit 1
fi
