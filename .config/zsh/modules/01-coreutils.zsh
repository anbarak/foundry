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

###############################################################################
# print_files — Pretty-print directory files with optional ASCII sanitization,
#               binary skipping, structured formatting, and ZIP export options.
#
# DESCRIPTION
#   Recursively or non-recursively traverses a directory, printing each file
#   with a header, filename label, and sanitized content. Includes options to
#   skip binary files and/or normalize text to ASCII for terminals that do not
#   support UTF-8. Can optionally create ZIP archives of:
#     • Original source files (preserving paths)
#     • Sanitized content snapshots (.txt files)
#
# USAGE
#   print_files <dir> [options]
#
# OPTIONS
#   -r
#       Recursively include files under <dir>.
#
#   -x "pattern1,pattern2,..."
#       Exclude files matching the provided name patterns (e.g. "*.log,secret*").
#       Default excludes: .DS_Store
#
#   -A, --ascii
#       Force ASCII-only output (strip or transliterate Unicode characters).
#
#   --no-skip-binary
#       Include binary files in printing (otherwise they are detected and skipped).
#
#   --zip <path>
#       Create a ZIP file containing ALL matched source files (including binaries),
#       preserving directory structure under <dir>.
#
#   --zip-snapshot <path>
#       Create a ZIP file containing SANITIZED text snapshots of each matched file.
#       Binary files become [binary file skipped] placeholders. Extensions = .txt
#
#   --no-print
#       Do not print file contents to stdout… only create ZIP outputs.
#
# NOTES
#   • Detects non-UTF-8 terminals and auto-enables ASCII fallback unless `--ascii` provided.
#   • Uses `zip`, `iconv`, GNU coreutils if available (fallback to BSD tools).
#   • Meant for text visualization, content review, backups, and sharing code snippets safely.
#
# EXAMPLES
#   # Pretty-print immediate files only
#   print_files scripts/
#
#   # Recursive with exclusions
#   print_files Cloudformations/scripts -r -x "*.pyc,*.zip"
#
#   # Sanitize all text to ASCII
#   print_files Cloudformations/scripts -r --ascii
#
#   # Create archive of raw files only (no printing)
#   print_files Cloudformations/scripts -r \
#       --zip /tmp/scripts.zip \
#       --no-print
#
#   # Print nicely and save a sanitized content snapshot ZIP
#   print_files Cloudformations/scripts -r \
#       --zip-snapshot ~/Desktop/scripts_snapshot.zip
#
#   # Copy formatted output to clipboard while saving raw ZIP
#   print_files Cloudformations/scripts -r \
#       --zip /tmp/scripts.zip | pbcopy
#
###############################################################################
print_files () {
  local recursive=false
  local exclude_patterns=(".DS_Store")
  local dir=""
  local force_ascii=false
  local skip_binary=true
  local zip_path=""
  local zip_snapshot=""
  local also_print=true

  _resolve_outpath () {
    # Expand ~ and respect absolute paths; otherwise make it relative to the caller (OLDPWD)
    local p="$1"
    case "$p" in
      /*)   printf '%s' "$p" ;;
      "~"|"~/"* ) printf '%s' "${p/#\~/$HOME}" ;;
      *)    printf '%s' "$OLDPWD/$p" ;;
    esac
  }

  _utf8_ok () {
    $force_ascii && return 1
    local loc="${LC_ALL:-${LANG:-}}"
    [[ "$loc" == *UTF-8* || "$loc" == *utf8* ]]
  }

  _echo () {
    if command -v gprintf >/dev/null 2>&1; then gprintf "%s\n" "$*"; else printf "%s\n" "$*"; fi
  }

  _cat () {
    if command -v gcat >/dev/null 2>&1; then gcat "$@"; else cat "$@"; fi
  }

  _is_binary () {
    # Return 0 if binary, 1 if text
    if command -v ggrep >/dev/null 2>&1; then
      ggrep -Iq . "$1" 2>/dev/null || return 0
    else
      grep -Iq . "$1" 2>/dev/null || return 0
    fi
    return 1
  }

  _cat_sanitized () {
    if _utf8_ok; then
      _cat "$1"
    else
      if command -v iconv >/dev/null 2>&1; then
        iconv -f UTF-8 -t ASCII//TRANSLIT "$1" 2>/dev/null || {
          if command -v gtr >/dev/null 2>&1; then gtr -cd '\11\12\15\40-\176' <"$1"; else tr -cd '\11\12\15\40-\176' <"$1"; fi
        }
      else
        if command -v gtr >/dev/null 2>&1; then gtr -cd '\11\12\15\40-\176' <"$1"; else tr -cd '\11\12\15\40-\176' <"$1"; fi
      fi
    fi
  }

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -r) recursive=true; shift ;;
      -x) IFS=',' read -r -A exclude_patterns <<< "$2"; shift 2 ;;
      -A|--ascii) force_ascii=true; shift ;;
      --no-skip-binary) skip_binary=false; shift ;;
      --zip) zip_path="$2"; shift 2 ;;
      --zip-snapshot) zip_snapshot="$2"; shift 2 ;;
      --no-print) also_print=false; shift ;;
      *) dir="$1"; shift ;;
    esac
  done

  if [[ -z "$dir" || ! -d "$dir" ]]; then
    _echo "Usage: print_files <dir> [-r] [-x pat1[,pat2,...]] [-A|--ascii] [--no-skip-binary] [--zip PATH] [--zip-snapshot PATH] [--no-print]" >&2
    return 1
  fi

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

  # Build find command
  local find_cmd=(find "$dir")
  $recursive || find_cmd+=(-maxdepth 1)
  find_cmd+=(-type f)
  for pattern in "${exclude_patterns[@]}"; do
    find_cmd+=(! -name "$pattern")
  done
  find_cmd+=(-print0)

  # Collect relative file paths for zipping
  local -a rel_files=()

  while IFS= read -r -d '' file; do
    # Always collect relative path for zip (preserve structure)
    local rel="${file#"$dir"/}"
    rel_files+=("$rel")

    local is_bin=false
    if _is_binary "$file"; then is_bin=true; fi

    if $also_print; then
      if $skip_binary && $is_bin; then
        _echo
        _echo "$HLINE"
        _echo "${FILE_PREFIX}${file}"
        _echo "$SLINE"
        _echo "[binary file skipped]"
        _echo
      else
        _echo
        _echo "$HLINE"
        _echo "${FILE_PREFIX}${file}"
        _echo "$SLINE"
        _cat_sanitized "$file"
        _echo
      fi
    fi
  done < <("${find_cmd[@]}")

  # Create a zip of the actual files (includes binaries, preserves paths)
  if [[ -n "$zip_path" ]]; then
    command -v zip >/dev/null 2>&1 || { _echo "Error: zip not found"; return 2; }
    (
      cd "$dir" || exit 2
      if (( ${#rel_files[@]} )); then
        local out; out="$(_resolve_outpath "$zip_path")"
        mkdir -p "$(dirname "$out")"
        # Optional: avoid silent overwrite
        # [[ -f "$out" ]] && rm -f "$out"
        zip -q -r "$out" "${rel_files[@]}"
      else
        _echo "No files matched to zip."
      fi
    )
    $also_print && _echo "✓ Wrote zip: $zip_path" >&2
  fi

  # Create a zip snapshot with sanitized text versions
  if [[ -n "$zip_snapshot" ]]; then
    command -v zip >/dev/null 2>&1 || { _echo "Error: zip not found"; return 2; }
    local tmpdir; tmpdir="$(mktemp -d)"
    (
      cd "$dir" || exit 2
      for rel in "${rel_files[@]}"; do
        local src="$rel"
        local dest="$tmpdir/$rel.txt"
        mkdir -p "$(dirname "$dest")"
        local abs="$PWD/$src"
        if _is_binary "$abs" && $skip_binary; then
          printf '[binary file skipped]\n' >"$dest"
        else
          if _utf8_ok; then
            _cat "$abs" >"$dest"
          else
            if command -v iconv >/dev/null 2>&1; then
              iconv -f UTF-8 -t ASCII//TRANSLIT "$abs" 2>/dev/null >"$dest" || {
                if command -v gtr >/dev/null 2>&1; then gtr -cd '\11\12\15\40-\176' <"$abs" >"$dest"; else tr -cd '\11\12\15\40-\176' <"$abs" >"$dest"; fi
              }
            else
              if command -v gtr >/dev/null 2>&1; then gtr -cd '\11\12\15\40-\176' <"$abs" >"$dest"; else tr -cd '\11\12\15\40-\176' <"$abs" >"$dest"; fi
            fi
          fi
        fi
      done
      local out; out="$(_resolve_outpath "$zip_snapshot")"
      mkdir -p "$(dirname "$out")"
      ( cd "$tmpdir" && zip -q -r "$out" . )
    )
    rm -rf "$tmpdir"
    $also_print && _echo "✓ Wrote snapshot zip: $zip_snapshot" >&2
  fi
}
