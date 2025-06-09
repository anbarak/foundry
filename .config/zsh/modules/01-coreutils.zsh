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
