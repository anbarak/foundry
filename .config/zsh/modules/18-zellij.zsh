# shellcheck shell=bash
# =============================================================================
# Zellij — mirror of tmux aliases (see 17-tmux.zsh for the tmux equivalents)
# =============================================================================
# Muscle memory: same 2-letter verbs as tmux, but with 'zj' prefix.
# Prefix chosen because 'z' is taken by zoxide and cannot be overridden.

alias zjs='zellij attach --create'              # Smart attach/start (use 99% of the time) — like tmux `ts`
alias zja='zellij attach'                       # Attach to specific session — like tmux `ta`
alias zjn='zellij --session'                    # Create new named session — like tmux `tn`
alias zjks='zellij kill-session'                # Kill specific session — like tmux `tks`
alias zjka='zellij kill-all-sessions --yes'     # Kill all sessions — like tmux `tka`
alias zjl='zellij list-sessions'                # List all sessions — like tmux `tl`
alias zjd='zellij delete-all-sessions --yes'    # Delete all EXITED sessions (cleanup)
alias zjr='zellij action reload-layout && echo "Zellij layout reloaded ✅"'  # Reload layout — like tmux `tmr`

# Convenience: jump into a resurrection-capable session named after current dir
# (like tmux-start's smart behavior — create/attach based on pwd)
zjw() {
  local session_name="${PWD:t}"  # basename of current dir
  zellij attach --create "$session_name"
}
