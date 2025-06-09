#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$HOME}"
MAX_RESULTS="${2:-20}"
SHOW_DETAILS="${RECENT_DETAILS:-false}"
MACHINE_OUTPUT="${RECENT_MACHINE:-false}"
INCLUDE_FILE="$HOME/.config/devtools/modfiles/include-locations.txt"

# Detect platform-specific stat syntax
if stat --version &>/dev/null; then
  # GNU stat (Linux or via Homebrew coreutils)
  STAT_FMT=(stat --format='%Y %n')
else
  # BSD stat (macOS default)
  STAT_FMT=(/usr/bin/stat -f '%m %N')
fi

# Files and paths to exclude
EXCLUDE_ARGS=(
  ! -name '.DS_Store'
  ! -path "$HOME/.zsh_history"
  ! -path "$HOME/.viminfo"
  ! -path "$HOME/.kube/cache/*"
  ! -path "$HOME/.kube/cache/http/*"
  ! -path "$HOME/.kube/cache/discovery/*"
)

SEARCH_PATHS=()
if [[ "$TARGET_DIR" == "$HOME" ]]; then
  if [[ -f "$INCLUDE_FILE" ]]; then
    echo "📘 Search locations loaded from: $INCLUDE_FILE"
    while IFS= read -r line; do
      [[ -z "$line" || "$line" =~ ^# ]] && continue
      expanded="${line//\$HOME/$HOME}"
      [[ -d "$expanded" ]] && SEARCH_PATHS+=("$expanded")
    done < "$INCLUDE_FILE"
  else
    echo -e "\033[33m⚠️ Warning: Include locations file not found: $INCLUDE_FILE\033[0m"
    exit 1
  fi
else
  SEARCH_PATHS=("$TARGET_DIR")
fi

echo "📂 Scanning: $TARGET_DIR"
echo "📄 Showing top $MAX_RESULTS recently modified files in: $TARGET_DIR"

# Debug: show active exclusions
# printf "🧹 Excluding patterns:\n%s\n" "${EXCLUDE_ARGS[@]}"

# Find files, extract modification times, and sort
mapfile -t FILES < <(
  for path in "${SEARCH_PATHS[@]}"; do
    [[ -d "$path" ]] && find "$path" -type f "${EXCLUDE_ARGS[@]}" -print0 2>/dev/null
  done \
  | xargs -0 "${STAT_FMT[@]}" \
  | sort -rn \
  | head -n "$MAX_RESULTS"
)

FILE_PATHS=("${FILES[@]##* }")

FILE_COUNT=$(printf "%s\n" "${FILES[@]}" | wc -l | tr -d ' ')
echo "🔍 Found $FILE_COUNT total files, showing top $MAX_RESULTS"

if [[ "$MACHINE_OUTPUT" == true ]]; then
  printf "%s\n" "${FILE_PATHS[@]}"
elif [[ "$SHOW_DETAILS" == true ]]; then
  eza -l --time=modified --sort=modified --reverse "${FILE_PATHS[@]}"
else
  for file in "${FILE_PATHS[@]}"; do
    mtime=$(date -r "$file" "+%Y-%m-%d %H:%M")
    printf "%-70s  %s\n" "${file/#$HOME/~}" "$mtime"
  done
fi

