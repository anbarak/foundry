# shellcheck shell=bash
# =============================================================================
# Yadm Aliases
# =============================================================================
alias ycm='yadm commit -m'                 # Commit staged changes with message
alias ypush='yadm push'                    # Push commits to remote
alias ydiff-unstaged='yadm diff'           # Show unstaged changes
alias ydiff-staged='yadm diff --cached'    # Show staged changes
alias ydiff-all='yadm diff HEAD'           # Show all changes (staged + unstaged)
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
ysmod () {
  local staged=() unstaged=() untracked=() deleted=()

  while IFS= read -r line; do
    code="${line:0:2}"
    file="${line:3}"

    case "$code" in
      '??') untracked+=("$file") ;;
      'A ') staged+=("new file:     $file") ;;
      'M ') staged+=("modified:     $file") ;;
      'D ') staged+=("deleted:      $file") ;;
      'AM') staged+=("added+mod:    $file") ;;
      ' M') unstaged+=("$file") ;;
      ' D') deleted+=("$file") ;;
      *)    unstaged+=("$file") ;;
    esac
  done < <(yadm status --short 2>/dev/null)

  # Print staged changes
  if [[ ${#staged[@]} -gt 0 ]]; then
    echo -e "\e[1;32m✅ Changes to be committed:\e[0m"
    for entry in "${staged[@]}"; do
      echo -e "  \e[32m$entry\e[0m"
    done
    echo
  fi

  # Print unstaged changes
  if [[ ${#unstaged[@]} -gt 0 ]]; then
    echo -e "\e[1;33m🟡 Changes not staged for commit:\e[0m"
    for entry in "${unstaged[@]}"; do
      echo -e "  \e[33m$entry\e[0m"
    done
    echo
  fi

  # Print deleted files (unstaged)
  if [[ ${#deleted[@]} -gt 0 ]]; then
    echo -e "\e[1;31m❌ Deleted (not staged):\e[0m"
    for entry in "${deleted[@]}"; do
      echo -e "  \e[31m$entry\e[0m"
    done
    echo
  fi

  # Print untracked files
  if [[ ${#untracked[@]} -gt 0 ]]; then
    echo -e "\e[1;90m🆕 Untracked files:\e[0m"
    for entry in "${untracked[@]}"; do
      echo -e "  \e[90m$entry\e[0m"
    done
    echo
  fi
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

# =============================================================================
# Multi-line commit using $EDITOR
# =============================================================================
ycmf() {
  local tmpfile
  tmpfile=$(mktemp /tmp/ycm-msg.XXXXXX)
  ${EDITOR:-vim} "$tmpfile"  # Open in your preferred editor
  yadm commit -aF "$tmpfile"
  rm -f "$tmpfile"
}
