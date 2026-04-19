#!/usr/bin/env zsh
# =============================================================================
# ~/.zshrc — bare plugin loading (zsh_unplugged)
# =============================================================================

# -----------------------------------------------------------------------------
# Performance profiling (conditional)
# -----------------------------------------------------------------------------
ZSH_PROFILE_FLAG="$HOME/.cache/.zsh-profile-enabled"
[[ -f "$ZSH_PROFILE_FLAG" ]] && zmodload zsh/zprof

# -----------------------------------------------------------------------------
# Powerlevel10k instant prompt — MUST stay near the top
# -----------------------------------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------------------------------------------------------------------
# Basics
# -----------------------------------------------------------------------------
export USER_HOME="$HOME"
[[ -f "$HOME/bin/foundry/detect-os.sh" ]] && source "$HOME/bin/foundry/detect-os.sh"

# -----------------------------------------------------------------------------
# PATH management
# -----------------------------------------------------------------------------
add_to_path() {
  for DIR in "$@"; do
    case ":$PATH:" in
      *":$DIR:"*) ;;
      *) PATH="$DIR:$PATH" ;;
    esac
  done
}

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

if [[ "$FOUNDRY_OS" == "macos" ]]; then
  add_to_path "/opt/homebrew/bin"
  export HOMEBREW_PREFIX="/opt/homebrew"
  add_to_path "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
  add_to_path "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"
elif [[ "$FOUNDRY_OS" == "linux" ]] || [[ "$FOUNDRY_OS" == "wsl" ]]; then
  add_to_path "/usr/local/bin"
fi

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  add_to_path "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"
  export MANPATH="$HOMEBREW_PREFIX/share/man:$MANPATH"
  export INFOPATH="$HOMEBREW_PREFIX/share/info:$INFOPATH"
  [[ -f "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc" ]] && source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc"
  [[ -f "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"
fi

add_to_path "$USER_HOME/.local/bin"

export PYENV_ROOT="$USER_HOME/.pyenv"
if [[ -d "$PYENV_ROOT" ]]; then
  [[ -d "$PYENV_ROOT/bin" ]] && add_to_path "$PYENV_ROOT/bin"
  [[ -d "$PYENV_ROOT/shims" ]] && add_to_path "$PYENV_ROOT/shims"
fi

_init_pyenv() {
  if [[ -z "$PYENV_INITIALIZED" && -d "$PYENV_ROOT" ]]; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    [[ ! -d "$PYENV_ROOT/bin" ]] && PATH="${PATH//$PYENV_ROOT\/bin:/}"
    export PYENV_INITIALIZED=1
  fi
}

python()  { _init_pyenv; unfunction python  2>/dev/null; command python  "$@"; }
python3() { _init_pyenv; unfunction python3 2>/dev/null; command python3 "$@"; }


add_to_path "$USER_HOME/go/bin" "$HOMEBREW_PREFIX/opt/go/libexec/bin"

export JAVA_HOME="$HOMEBREW_PREFIX/opt/openjdk"
add_to_path "$JAVA_HOME/bin"

add_to_path "$USER_HOME/bin" "$USER_HOME/bin/tools" "$USER_HOME/bin/git"
add_to_path "$USER_HOME/.krew/bin"
[[ -d "$USER_HOME/scripts" ]] && add_to_path "$USER_HOME/scripts"
[[ -d "$USER_HOME/code/cf/datalot/.datalot" ]] && add_to_path "$USER_HOME/code/cf/datalot/.datalot/bin"

_init_asdf() {
  if [[ -z "$ASDF_INITIALIZED" && -f "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" ]]; then
    source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"
    export ASDF_INITIALIZED=1
  fi
}
asdf() { _init_asdf; unfunction asdf 2>/dev/null; command asdf "$@"; }

# -----------------------------------------------------------------------------
# Completion setup
# -----------------------------------------------------------------------------
mkdir -p "$HOME/.zsh/completions"
fpath+=("$HOME/.zsh/completions")

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
fi

export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${HOST}-${ZSH_VERSION}"
mkdir -p "${ZSH_COMPDUMP:h}"

if [[ -f "$ZSH_COMPDUMP" ]] && [[ -n "$(command find "$ZSH_COMPDUMP" -mtime +1 2>/dev/null)" ]]; then
  rm -f "$ZSH_COMPDUMP"
fi

# -----------------------------------------------------------------------------
# Plugins
# -----------------------------------------------------------------------------
[[ -f "$USER_HOME/.zshrc.plugins" ]] && source "$USER_HOME/.zshrc.plugins"

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# -----------------------------------------------------------------------------
# Directory nav
# -----------------------------------------------------------------------------
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# -----------------------------------------------------------------------------
# SSH keychain (skip in multiplexers)
# -----------------------------------------------------------------------------
# SSH keychain — only add if not already loaded (saves ~500ms per shell)
_ssh_key="$USER_HOME/.ssh/id_ed25519_centerfield"
if [[ -z "$TMUX" && -z "$ZELLIJ" && -f "$_ssh_key" ]]; then
  _ssh_fp=$(ssh-keygen -lf "$_ssh_key" 2>/dev/null | awk '{print $2}')
  if [[ -n "$_ssh_fp" ]] && ! ssh-add -l 2>/dev/null | grep -q "$_ssh_fp"; then
    ssh-add --apple-use-keychain "$_ssh_key" >/dev/null 2>&1
  fi
  unset _ssh_fp
fi
unset _ssh_key

# -----------------------------------------------------------------------------
# Local config (aliases, metrics, secrets)
# -----------------------------------------------------------------------------
# Run compinit early — .zshrc.local calls compdef and needs it ready
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP" -C

[[ -f "$USER_HOME/.zshrc.local" ]] && source "$USER_HOME/.zshrc.local"

# -----------------------------------------------------------------------------
# vi mode
# -----------------------------------------------------------------------------
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^R' history-incremental-search-backward
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history

# -----------------------------------------------------------------------------
# p10k
# -----------------------------------------------------------------------------
[[ -f "$USER_HOME/.p10k.zsh" ]] && source "$USER_HOME/.p10k.zsh"
[[ -f "$USER_HOME/.p10k-tiny-aws.zsh" ]] && source "$USER_HOME/.p10k-tiny-aws.zsh"

# -----------------------------------------------------------------------------
# Final cleanup
# -----------------------------------------------------------------------------
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
precmd_functions=(${precmd_functions:#_pyenv_virtualenv_hook})
