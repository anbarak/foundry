# shellcheck shell=bash
# =============================================================================
# GNU Coreutils Aliases
# =============================================================================
alias dir='gdir'
alias vdir='gvdir'
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='gmkdir -p'
alias rmdir='grmdir'
alias chown='gchown'
alias chgrp='gchgrp'
alias chmod='gchmod'
alias touch='gtouch'
alias ln='gln'
alias install='ginstall'
alias du='gdu'
alias df='gdf'
alias pwd='gpwd'
alias date='gdate'
alias uname='guname'
alias head='ghead'
alias tail='gtail'
alias cat='gcat'
alias tac='gtac'
alias echo='gecho'
alias tee='gtee'
alias wc='gwc'
alias who='gwho'
alias id='gid'
alias groups='ggroups'
alias stty='gstty'
alias env='genv'
alias sort='gsort'
alias cut='gcut'
alias paste='gpaste'
alias sed='gsed'
alias grep='ggrep --color=auto'
alias find='gfind'
alias locate='glocate'
alias xargs='gxargs'
alias split='gsplit'
alias uniq='guniq'
alias join='gjoin'
alias comm='gcomm'
alias diff='/opt/homebrew/opt/diffutils/bin/diff'
alias patch='gpatch'
alias tr='gtr'
alias expand='gexpand'
alias unexpand='gunexpand'
alias fmt='gfmt'
alias fold='gfold'
alias pr='gpr'
alias tsort='gtsort'
alias nl='gnl'
alias numfmt='gnumfmt'
alias seq='gseq'
alias yes='gyes'
alias basename='gbasename'
alias dirname='gdirname'
alias realpath='grealpath'

# =============================================================================
# Modern CLI Replacements
# =============================================================================

# 'cat', 'ls', 'grep' replacements
alias bat='bat'
alias eza='eza'
alias ls='eza'
alias ll='eza -lh'
alias la='eza -lah'
alias rg='rg --hidden --no-ignore' # safe to use alongside ggrep

# Dev workflow helpers
alias lintdot='"$HOME/bin/dev-env/lint-dotfiles"'
alias ycommit='"$HOME/bin/git/yadm-commit"'
alias devsetup='"$HOME/bin/setup"'

# Open file and auto-create directories
vif() {
  [[ -z "$1" ]] && echo "Usage: vif <file-path>" && return 1
  mkdir -p "$(dirname "$1")" && vi "$1"
}

# =============================================================================
# File Search Helpers
# =============================================================================

export RECENT_EXCLUDE=true                      # Enable exclusion logic
export RECENT_EXCLUDE_PATHS_ONLY=true           # Exclude by path (e.g. Library/Caches)
export RECENT_EXCLUDE_NAMES_ONLY=true           # Exclude by file patterns (e.g. *.log)

# Only define recent helpers if script exists
if [[ -x "$HOME/bin/tools/dev/find-recent-files.sh" ]]; then
  # Show top N recently modified files (fast, plain)
  recent() {
    local target="${1:-$HOME}"
    local count="${2:-20}"
    "$HOME/bin/tools/dev/find-recent-files.sh" "$target" "$count"
  }

  # Show top N recently modified files with details via eza
  recent-details() {
    local target="${1:-$HOME}"
    local count="${2:-20}"
    RECENT_DETAILS=true "$HOME/bin/tools/dev/find-recent-files.sh" "$target" "$count"
  }

  # Interactive FZF variant for top N recently modified files
  recent-fzf() {
    local target="${1:-$HOME}"
    local count="${2:-20}"
    local script="$HOME/bin/tools/dev/find-recent-files.sh"

    # Use plain output (not RECENT_DETAILS) which starts with the full path
    RECENT_DETAILS=false RECENT_MACHINE=false "$script" "$target" "$count" \
      | grep -E '^(/|~)' \
      | fzf --preview='[[ -f $(awk "{print \$1}" <<< {}) ]] && bat --style=numbers --color=always --line-range :100 $(awk "{print \$1}" <<< {}) || echo "⚠️ File not found."' \
            --with-nth=1.. \
            --preview-window=right:30%
  }
fi

print_files () {
  ###############################################################################
  # print_files — Pretty-print directory files with optional ASCII sanitization,
  #               binary skipping, structured formatting, selective exclusions,
  #               and ZIP export capabilities.
  #
  # DESCRIPTION
  #   Traverses a directory (recursively or not) and prints each file with a
  #   formatted header, filename label, and sanitized content. Designed for
  #   reviewing code, debugging deployments, generating snapshots, and safely
  #   sharing file contents without leaking binary data or unreadable characters.
  #
  #   Supports:
  #     • Name-based exclusions (-x)
  #     • Full-path exclusions (-X / --exclude-path)
  #     • Binary file detection and skipping
  #     • UTF-8 vs ASCII output selection (auto or manual)
  #     • ZIP archive creation:
  #         - Raw matched files (preserving structure)
  #         - Sanitized text snapshots (.txt versions)
  #     • Optional auto-timestamped ZIP paths (--zip-auto / --zip-snapshot-auto)
  #
  # USAGE
  #   print_files <dir> [options]
  #
  ###############################################################################

  usage() {
    cat <<'EOF'
Usage: print_files <dir> [options]

Options:
  -r
      Recursively include files under <dir>.

  -x "pattern1,pattern2,..."
      Exclude files by basename (find -name).
      Default excludes: ".DS_Store"

  -X "path1,path2,..." | --exclude-path "path1,path2,..."
      Exclude files or directories by full path (find -path).
      Example: -X "*/node_modules/*,*/.git/*"

  -A, --ascii
      Force ASCII-only output (transliterate/strip Unicode).

  --no-skip-binary
      Do not skip binary files when printing.

  --zip PATH
      Create a ZIP file of all matched source files.

  --zip-auto
      Auto-generate a timestamped ZIP path under $HOME/Downloads using <dir>
      as the base name. Ignored if --zip PATH is already provided.

  --zip-snapshot PATH
      Create a ZIP of sanitized text snapshots (.txt) of each file.

  --zip-snapshot-auto
      Auto-generate a timestamped snapshot ZIP path under $HOME/Downloads
      (suffix "-snapshot"). Ignored if --zip-snapshot PATH is already provided.

  --no-print
      Do not print file contents; only perform ZIP/snapshot actions.

  --quiet
      Suppress status lines (e.g. '✓ Wrote zip: ...') on stderr. Useful for
      scripting when you only care about stdout or want completely silent runs.

Examples:
  # Pretty-print immediate files only
  print_files MyDirectory

  # Recursive with basename exclusions
  print_files MyDirectory -r -x "*.pyc,*.zip"

  # Recursive with full path exclusions
  print_files . -r -X "*/node_modules/*,*/.git/*"

  # Force ASCII sanitization
  print_files MyDirectory -r --ascii

  # Create archive of raw files (no printing)
  print_files MyDirectory -r \
      --zip /tmp/scripts.zip --no-print

  # Create sanitized snapshot archive
  print_files scripts -r \
      --zip-snapshot ~/Desktop/scripts_snapshot.zip --no-print

  # Timestamped ZIP export without printing (auto filename)
  print_files MyDirectory -r \
      --zip-auto --no-print

EOF
  }

  ###############################################################################
  # OPTION FLAGS & INTERNAL STATE
  ###############################################################################

  local recursive=false                      # -r flag → recurse into subdirs
  local exclude_patterns=(".DS_Store")       # -x name patterns (basename)
  local -a exclude_paths=()                  # -X path patterns (full path)
  local dir=""                               # target directory
  local force_ascii=false                    # force ASCII output
  local skip_binary=true                     # skip binary files instead of printing
  local zip_path=""                          # --zip output
  local zip_snapshot=""                      # --zip-snapshot output
  local zip_auto=false                       # --zip-auto flag
  local zip_snapshot_auto=false              # --zip-snapshot-auto flag
  local also_print=true                      # --no-print flag
  local quiet=false                          # --quiet flag → suppress status lines

  ###############################################################################
  # INTERNAL HELPERS
  ###############################################################################

  # Resolve relative, absolute, and ~ paths
  _resolve_outpath () {
    local p="$1"
    case "$p" in
      (/*) printf '%s' "$p" ;;                       # Absolute
      ("~" | "~/"*) printf '%s' "${p/#\~/$HOME}" ;; # Home shortcut
      (*) printf '%s' "$OLDPWD/$p" ;;               # Relative to previous directory
    esac
  }

  # Create directory (GNU coreutils if available, fallback to BSD mkdir)
  _mkdir_p () {
    if command -v gmkdir > /dev/null 2>&1; then
      gmkdir -p "$1"
    else
      mkdir -p "$1"
    fi
  }

  # Detect if terminal supports UTF-8 → used for borders + emojis
  _utf8_ok () {
    $force_ascii && return 1
    local loc="${LC_ALL:-${LANG:-}}"
    [[ "$loc" == *UTF-8* || "$loc" == *utf8* ]]
  }

  # printf wrapper (gprintf if available)
  _echo () {
    if command -v gprintf > /dev/null 2>&1; then
      gprintf "%s\n" "$*"
    else
      printf "%s\n" "$*"
    fi
  }

  # cat wrapper choosing gcat if installed
  _cat () {
    if command -v gcat > /dev/null 2>&1; then
      gcat "$@"
    else
      cat "$@"
    fi
  }

  # Binary detection using grep -Iq
  # Returns 0 = binary, 1 = text
  _is_binary () {
    if command -v ggrep > /dev/null 2>&1; then
      ggrep -Iq . "$1" 2> /dev/null || return 0
    else
      grep -Iq . "$1" 2> /dev/null || return 0
    fi
    return 1
  }

  # Print sanitized content (ASCII fallback if needed)
  _cat_sanitized () {
    if _utf8_ok; then
      _cat "$1"
      return
    fi

    # Convert UTF → ASCII if iconv exists
    if command -v iconv > /dev/null 2>&1; then
      if iconv -f UTF-8 -t ASCII//TRANSLIT "$1" 2>/dev/null; then
        return
      fi
    fi

    # Last resort: strip to printable ASCII
    if command -v gtr > /dev/null 2>&1; then
      gtr -cd '\11\12\15\40-\176' < "$1"
    else
      tr -cd '\11\12\15\40-\176' < "$1"
    fi
  }

  # Return file size in bytes using gstat, BSD stat, or wc -c (best available method).#
  _file_size_bytes () {
    local path="$1"

    if [[ ! -f "$path" ]]; then
      return 1
    fi

    # Try gstat first
    if command -v gstat >/dev/null 2>&1; then
      gstat -c '%s' -- "$path" 2>/dev/null && return 0
    fi

    # Try BSD stat
    if command -v stat >/dev/null 2>&1; then
      stat -f '%z' "$path" 2>/dev/null && return 0
    fi

    # Fallback to wc (use absolute paths to bypass aliases)
    if [[ -f "$path" ]]; then
      /usr/bin/wc -c < "$path" 2>/dev/null | /usr/bin/tr -d '[:space:]'
    fi
  }

  # Print a standardized status line for zip outputs (with size if available)
  _echo_zip_status () {
    # Honor --quiet: no status lines at all
    $quiet && return 0

    local label="$1"   # e.g. "Wrote zip", "Wrote snapshot zip"
    local path="$2"
    local size=""

    size="$(_file_size_bytes "$path" || true)"

    if [[ -n "$size" ]]; then
      local human="$(_human_size "$size")"
      _echo "✓ ${label}: ${path} (${human}, ${size} bytes)" >&2
    else
      _echo "✓ ${label}: ${path}" >&2
    fi
  }

  _human_size () {
    local bytes="$1"
    local unit value

    # Ensure it's numeric; if not, just echo raw
    if [[ -z "$bytes" || ! "$bytes" =~ ^[0-9]+$ ]]; then
      printf "%s B" "$bytes"
      return
    fi

    if (( bytes < 1024 )); then
      printf "%d B" "$bytes"
      return
    elif (( bytes < 1024 * 1024 )); then
      unit="KB"
      value=$(( bytes * 10 / 1024 ))
    elif (( bytes < 1024 * 1024 * 1024 )); then
      unit="MB"
      value=$(( bytes * 10 / 1024 / 1024 ))
    elif (( bytes < 1024 * 1024 * 1024 * 1024 )); then
      unit="GB"
      value=$(( bytes * 10 / 1024 / 1024 / 1024 ))
    else
      unit="TB"
      value=$(( bytes * 10 / 1024 / 1024 / 1024 / 1024 ))
    fi

    # value is scaled by 10 → X.Y
    printf "%d.%d %s" "$(( value / 10 ))" "$(( value % 10 ))" "$unit"
  }

  ###############################################################################
  # ARGUMENT PARSING
  ###############################################################################

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -r)
        recursive=true
        shift
        ;;
      -x)
        IFS=',' read -r -A exclude_patterns <<< "$2"
        shift 2
        ;;
      -X|--exclude-path)
        IFS=',' read -r -A exclude_paths <<< "$2"
        shift 2
        ;;
      -A|--ascii)
        force_ascii=true
        shift
        ;;
      --no-skip-binary)
        skip_binary=false
        shift
        ;;
      --zip)
        zip_path="$2"
        shift 2
        ;;
      --zip-auto)
        zip_auto=true
        shift
        ;;
      --zip-snapshot)
        zip_snapshot="$2"
        shift 2
        ;;
      --zip-snapshot-auto)
        zip_snapshot_auto=true
        shift
        ;;
      --no-print)
        also_print=false
        shift
        ;;
      --quiet)
        quiet=true
        shift
        ;;
      *)
        dir="$1"
        shift
        ;;
    esac
  done

  ###############################################################################
  # USAGE CHECK
  ###############################################################################

  if [[ -z "$dir" ]]; then
    _echo "Error: missing <dir> argument." >&2
    usage >&2
    return 1
  fi

  if [[ ! -d "$dir" ]]; then
    _echo "Error: directory not found: $dir" >&2
    usage >&2
    return 1
  fi

  ###############################################################################
  # AUTO-GENERATED ZIP PATHS (OPTIONAL ENHANCEMENT)
  ###############################################################################

  if $zip_auto || $zip_snapshot_auto; then
    local dir_basename ts
    dir_basename="${dir%/}"
    dir_basename="${dir_basename##*/}"
    ts="$(date '+%Y%m%d-%H%M%S')"      # e.g. 20251126-185611

    if $zip_auto && [[ -z "$zip_path" ]]; then
      zip_path="$HOME/Downloads/${dir_basename:-files}-${ts}.zip"
    fi

    if $zip_snapshot_auto && [[ -z "$zip_snapshot" ]]; then
      zip_snapshot="$HOME/Downloads/${dir_basename:-files}-snapshot-${ts}.zip"
    fi
  fi

  ###############################################################################
  # UI ELEMENTS (UNICODE OR ASCII)
  ###############################################################################

  local HLINE SLINE FILE_PREFIX

  if _utf8_ok; then
    HLINE="══════════════════════════════════════════════════════"
    SLINE="──────────────────────────────────────────────────────"
    FILE_PREFIX="📄 "
  else
    HLINE="======================================================"
    SLINE="------------------------------------------------------"
    FILE_PREFIX=""
  fi

  ###############################################################################
  # BUILD FIND COMMAND
  ###############################################################################
  # We build find dynamically instead of piping to avoid quoting bugs.

  local find_cmd=(find "$dir")
  $recursive || find_cmd+=(-maxdepth 1)

  # Only files
  find_cmd+=(-type f)

  # Exclude basenames (-x)
  for pattern in "${exclude_patterns[@]}"; do
    find_cmd+=(! -name "$pattern")
  done

  # Exclude full path matches (-X / --exclude-path)
  for pattern in "${exclude_paths[@]}"; do
    find_cmd+=(! -path "$pattern")
  done

  find_cmd+=(-print0)

  ###############################################################################
  # PROCESS FILES
  ###############################################################################

  local -a rel_files=()

  while IFS= read -r -d '' file; do
    # Compute relative path for ZIP/snapshot creation
    local rel="${file#"$dir"/}"
    rel_files+=("$rel")

    local is_bin=false
    if _is_binary "$file"; then
      is_bin=true
    fi

    if $also_print; then
      _echo
      _echo "$HLINE"
      _echo "${FILE_PREFIX}${file}"
      _echo "$SLINE"

      if $skip_binary && $is_bin; then
        _echo "[binary file skipped]"
      else
        _cat_sanitized "$file"
      fi

      _echo
    fi
  done < <("${find_cmd[@]}")

  ###############################################################################
  # ZIP MODE (raw files)
  ###############################################################################

  if [[ -n "$zip_path" ]]; then
    if ! command -v zip >/dev/null 2>&1; then
      _echo "Error: zip not found"
      return 2
    fi

    local resolved_zip
    resolved_zip="$(_resolve_outpath "$zip_path")"

    (
      cd "$dir" || exit 2
      if (( ${#rel_files[@]} )); then
        _mkdir_p "$(dirname "$resolved_zip")"
        zip -q -r "$resolved_zip" "${rel_files[@]}"
      else
        _echo "No files matched to zip."
        exit 0
      fi
    )

    # Only print status if we actually zipped something
    if (( ${#rel_files[@]} )); then
      _echo_zip_status "Wrote zip" "$resolved_zip"
    fi
  fi

  ###############################################################################
  # SNAPSHOT ZIP MODE (text-converted output)
  ###############################################################################

  if [[ -n "$zip_snapshot" ]]; then
    if ! command -v zip >/dev/null 2>&1; then
      _echo "Error: zip not found"
      return 2
    fi

    local tmpdir
    tmpdir="$(mktemp -d)"

    local resolved_snap
    resolved_snap="$(_resolve_outpath "$zip_snapshot")"

    (
      cd "$dir" || exit 2

      if (( ${#rel_files[@]} )); then
        for rel in "${rel_files[@]}"; do
          local src="$rel"
          local dest="$tmpdir/$rel.txt"
          _mkdir_p "$(dirname "$dest")"

          local abs="$PWD/$src"

          if _is_binary "$abs" && $skip_binary; then
            printf '[binary file skipped]\n' > "$dest"
          else
            _cat_sanitized "$abs" > "$dest"
          fi
        done

        _mkdir_p "$(dirname "$resolved_snap")"
        (
          cd "$tmpdir" && zip -q -r "$resolved_snap" .
        )
      else
        _echo "No files matched to snapshot zip."
        exit 0
      fi
    )

    if command -v trash >/dev/null 2>&1; then
      trash -rf "$tmpdir" >/dev/null 2>&1
    else
      rm -rf "$tmpdir"
    fi

    if (( ${#rel_files[@]} )); then
      _echo_zip_status "Wrote snapshot zip" "$resolved_snap"
    fi
  fi
}
