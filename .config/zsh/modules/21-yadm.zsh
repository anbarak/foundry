# shellcheck shell=bash
# =============================================================================
# Yadm
# =============================================================================
alias yaddall='yadm add -A'               # Stage all tracked and untracked changes safely
alias ycm='yadm commit -m'                 # Commit staged changes with message
alias ycma='yaddall && ycm'                # Add all changes and commit (safe)
alias ypush='yadm push'                    # Push commits to remote
alias ycmap='ycma && ypush'                # Add, commit, and push in one command
alias ystatus='yadm status'                # Check repo status
alias ydiff='yadm diff'                    # Show unstaged diffs
alias ypull='yadm pull --rebase'           # Pull with rebase for cleaner history
alias yfetch='yadm fetch'                  # Fetch only, no merge
alias yresolve='yadm add -u && yadm rebase --continue'  # Resolve rebase conflicts: stage updated files and continue
