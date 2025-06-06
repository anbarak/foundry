# shellcheck shell=bash
# =============================================================================
# Yadm
# =============================================================================
alias ycm='yadm commit -m'                 # Commit staged changes with message
alias ypush='yadm push'                    # Push commits to remote
alias ystatus='yadm status'                # Check repo status
alias ydiff='yadm diff'                    # Show unstaged changes
alias ydiffc='yadm diff --cached'          # Show staged changes
alias ydiffa='yadm diff HEAD'              # Show all changes (staged + unstaged)
alias ypull='yadm pull --rebase'           # Pull with rebase for cleaner history
alias yfetch='yadm fetch'                  # Fetch only, no merge
yadd() {
  if [ $# -eq 0 ]; then
    echo "Usage: yadd <file> [more files...]"
    return 1
  fi
  yadm add "$@"
}
