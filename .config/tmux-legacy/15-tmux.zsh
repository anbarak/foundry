# shellcheck shell=bash
# =============================================================================
# Tmux
# =============================================================================
alias ts="$HOME/bin/dev/tmux-start"   # Smart attach/start/restore (use this 99% of the time)
alias ta='tmux attach -t'             # Attach to specific session
alias tn='tmux new -s'                # Create a new named session
alias tks='tmux kill-session -t'      # Kill a specific session
alias tka='tmux kill-server'          # Kill all tmux sessions/server
alias tl='tmux ls'                    # List all tmux sessions
alias tmr='tmux source-file ~/.tmux.conf && tmux display-message "Config reloaded ✅"'  # Reload tmux config
