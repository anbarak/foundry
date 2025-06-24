#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

LOG_FILE="$HOME/logs/brew-maintenance.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1
exec 2>&1

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

quit_app_if_running() {
  local app_name="$1"
  if osascript -e "application \"$app_name\" is running" 2>/dev/null | grep -q true; then
    log INFO "🛑 Quitting $app_name before upgrade..."
    osascript -e "quit app \"$app_name\"" || true
    sleep 2
  fi
}

get_skipped_items() {
  local -n out=$1
  out=()

  mapfile -t casks < <(brew outdated --cask --greedy | grep -v '^\s*$')

  for cask in "${casks[@]}"; do
    local json app_paths app_path full_path caskroom_path
    if ! json=$(brew info --cask --json=v2 "$cask" 2>/dev/null); then
      continue
    fi

    caskroom_path="/opt/homebrew/Caskroom/$cask"
    local needs_privilege=false

    # ── Heuristic 1: installer, uninstall, or pkg artifacts ──
    if jq -e '
      .casks[0] |
      .uninstall or
      .installer or
      (.artifacts[]? | select(type == "object" and (has("pkg") or has("installer") or has("uninstall")))
    )' <<<"$json" >/dev/null; then
      needs_privilege=true
    fi

    # ── Heuristic 2: installed app(s) not writable ──
    mapfile -t app_paths < <(jq -r '.casks[0].app[]?' <<<"$json")
    for app_path in "${app_paths[@]}"; do
      full_path="/Applications/$app_path"
      if [[ -e "$full_path" && ! -w "$full_path" ]]; then
        needs_privilege=true
        break
      fi
    done

    # ── Heuristic 3: caskroom dir not writable ──
    if [[ -d "$caskroom_path" && ! -w "$caskroom_path" ]]; then
      needs_privilege=true
    fi

    if [[ "$needs_privilege" == true ]]; then
      out+=("cask:$cask")
    fi
  done
}

run_maintenance() {
  local skipped=()
  get_skipped_items skipped

  log INFO "📦 Running brew update & upgrade..."
  brew update

  # Upgrade all formulae except those needing sudo
  mapfile -t outdated_formulas < <(brew outdated --formula | grep -v '^\s*$')
  for formula in "${outdated_formulas[@]}"; do
    log INFO "⬆️  Upgrading $formula..."
    brew upgrade "$formula"
  done

  # Upgrade all casks except skipped ones
  mapfile -t outdated_casks < <(brew outdated --cask --greedy | grep -v '^\s*$')
  for cask in "${outdated_casks[@]}"; do
    if printf '%s\n' "${skipped[@]}" | grep -q "cask:$cask"; then
      log INFO "⏭️  Skipping $cask (requires sudo)"
    else
      log INFO "⬆️  Upgrading cask: $cask..."
      # Get app name from the cask metadata
      app_name=$(brew info --cask --json=v2 "$cask" | jq -r '.casks[0].app[0]' 2>/dev/null || echo "")
      if [[ -n "$app_name" ]]; then
        quit_app_if_running "$app_name"
      fi

      # Check if existing app bundle is non-writable inside Caskroom
      old_version=$(brew list --cask --versions "$cask" | awk '{print $2}')
      caskroom_dir="/opt/homebrew/Caskroom/$cask/$old_version"
      if [[ -d "$caskroom_dir" ]]; then
        if ! find "$caskroom_dir" -type d -perm -u=w | grep -q .; then
          log INFO "⏭️  Skipping $cask due to non-writable Caskroom path"
          skipped+=("cask:$cask")
          continue
        fi
      fi

      brew upgrade --cask "$cask"
    fi
  done

  log INFO "🧹 Cleaning up unused packages..."
  brew cleanup -s

  log INFO "🩺 Checking system health..."
  brew doctor || true
  brew outdated || true

  BREWFILE="$HOME/.config/homebrew/Brewfile"
  if [[ -f "$BREWFILE" ]]; then
    brew bundle dump --file="$BREWFILE" --force 2> >(grep -v "Their taps are in use" >&2)
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
