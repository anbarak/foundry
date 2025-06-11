# shellcheck shell=bash
# =============================================================================
# Yadm Aliases
# =============================================================================
alias ycm='yadm commit -m'                 # Commit staged changes with message
alias ypush='yadm push'                    # Push commits to remote
alias ydiff='yadm diff'                    # Show unstaged changes
alias ydiffc='yadm diff --cached'          # Show staged changes
alias ydiffa='yadm diff HEAD'              # Show all changes (staged + unstaged)
alias ypull='yadm pull --rebase'           # Pull with rebase for cleaner history
alias yfetch='yadm fetch'                  # Fetch only, no merge
alias ylog='yadm log --oneline --graph --decorate'                                 # Inspect commit history
alias ylogfull='yadm log --graph --abbrev-commit --decorate --date=relative --all' # Full decorated history
alias ylogpatch='yadm log -p --stat --color'                                       # Show diffs with stats

# =============================================================================
# Concise, colorized yadm status
# =============================================================================
ys() {
  local git_bin yadm_dir yadm_work
  git_bin=$(command -v git)
  yadm_dir="$HOME/.local/share/yadm/repo.git"
  yadm_work="$HOME"

  if [[ -t 1 ]]; then
    # Interactive shell: use config-based color (portable)
    GIT_CONFIG_PARAMETERS="'color.ui=always'" \
    GIT_PAGER=cat \
      "$git_bin" --git-dir="$yadm_dir" --work-tree="$yadm_work" \
      status --branch --untracked-files=normal \
      | GREP_COLORS='ms=01;32' grep --color=always -Ev 'Operation not permitted|Permission denied|No such file or directory'
  else
    "$git_bin" --git-dir="$yadm_dir" --work-tree="$yadm_work" status
  fi
}

# Concise yadm status (no untracked files)
alias ysc='GIT_PAGER=cat yadm status --branch --untracked-files=no'

# Concise yadm status (only modified/added files — no .DS_Store, etc.)
ysmod() {
  yadm status --short 2>/dev/null | grep "^[ MARC][ MD]" | while IFS= read -r line; do
    code="${line:0:2}"
    file="${line:3}"
    case "$code" in
      '??') desc="UNTRACKED"         color=90 ;;
      'A ') desc="ADDED"             color=32 ;;
      ' M') desc="MODIFIED"          color=33 ;;
      'M ') desc="STAGED"            color=36 ;;
      'MM') desc="MODIFIED+STAGED"   color=36 ;;
      ' D') desc="DELETED"           color=31 ;;
      'D ') desc="DELETED+STAGED"    color=35 ;;
      *)    desc="$code"             color=37 ;;
    esac
    printf "\e[1;${color}m%-17s\e[0m %s\n" "$desc" "$file"
  done
}

# the default quick check
alias ystatus='ysmod'

# =============================================================================
# Stage files
# =============================================================================
yadd() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: yadd <file> [more files...]"
    return 1
  fi
  yadm add "$@"
}
compdef _files yadd

# =============================================================================
# List changed files (staged + unstaged)
# =============================================================================
yfiles() {
  yadm status --short 2>/dev/null | awk '{print $2}' | sort -u
}
compdef _files yfiles

# =============================================================================
# Fuzzy add modified/staged files
# =============================================================================
yaddfuzzy() {
  local file
  file=$(yfiles | fzf --prompt="Stage file: " --height=40% --reverse) || return 1
  yadd "$file"
}
