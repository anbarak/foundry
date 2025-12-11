#!/usr/bin/env zsh

# Performance profiling (comment out when not needed)
# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$(basename "$TTY").zsh" ]; then
  # shellcheck source=/dev/null
  . "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$(basename "$TTY").zsh"
fi

#####################################################################################
# This is your main zsh configuration file. It contains settings specific to your   #
# zsh environment, such as aliases, keybindings, and environment variables. It      #
# should ideally be focused on core functionality and avoid clutter.                #
#####################################################################################

# Set USER_HOME variable
export USER_HOME="$HOME"

# Function to add paths only if they are not already in PATH
add_to_path() {
  for DIR in "$@"; do
    case ":$PATH:" in
      *":$DIR:"*) ;;
      *) PATH="$DIR:$PATH" ;;
    esac
  done
}

# Reset PATH to a minimal default to avoid duplicates
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Ensure Homebrew is in the PATH
add_to_path "/opt/homebrew/bin"

export HOMEBREW_PREFIX="/opt/homebrew"

# Add GNU coreutils to PATH for standard behavior (ls, cat, etc.)
# ⚠️ May cause issues with GMP/Python builds — review with `brew doctor`
add_to_path "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
add_to_path "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"

# Homebrew paths
if [ -n "$HOMEBREW_PREFIX" ]; then
  add_to_path "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"
  export MANPATH="$HOMEBREW_PREFIX/share/man:$MANPATH"
  export INFOPATH="$HOMEBREW_PREFIX/share/info:$INFOPATH"

  # Cloud SDK paths
  add_to_path "$HOMEBREW_PREFIX/share/google-cloud-sdk/bin"
fi

# Docker
add_to_path "/Applications/Docker.app/Contents/Resources/bin"

# Python paths
export PYTHON_USER_BASE="$USER_HOME/Library/Python/3.x/bin"
add_to_path "$PYTHON_USER_BASE"  # Replace 3.x with your Python version
add_to_path "$USER_HOME/.local/bin"  # For pipx and Poetry-installed tools

# Pyenv config
export PYENV_ROOT="$USER_HOME/.pyenv"

if [ -d "$PYENV_ROOT" ]; then
  add_to_path "$PYENV_ROOT/bin" "$PYENV_ROOT/shims"
fi

# Lazy init - only when python is actually used
_init_pyenv() {
  if [[ -z "$PYENV_INITIALIZED" && -d "$PYENV_ROOT" ]]; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    export PYENV_INITIALIZED=1
  fi
}

# Wrapper function
python() {
  _init_pyenv
  unfunction python 2>/dev/null
  command python "$@"
}

python3() {
  _init_pyenv
  unfunction python3 2>/dev/null
  command python3 "$@"
}

# Apple security paths
add_to_path "/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin" \
            "/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin" \
            "/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin"

# Go paths
add_to_path "$USER_HOME/go/bin" "$HOMEBREW_PREFIX/opt/go/libexec/bin"

# Add custom tools to PATH
add_to_path "$USER_HOME/bin/tools"

# Java paths
export JAVA_HOME="$HOMEBREW_PREFIX/opt/openjdk"
add_to_path "$JAVA_HOME/bin"

# Runner scripts path
add_to_path "$USER_HOME/bin"
add_to_path "$USER_HOME/bin/tools"
add_to_path "$USER_HOME/bin/git"

# Add krew path
add_to_path "$USER_HOME/.krew/bin"

if [ -d "$USER_HOME/scripts" ]; then
  add_to_path "$USER_HOME/scripts"
fi

if [ -d "$USER_HOME/code/cf/datalot/.datalot" ]; then
  add_to_path "$USER_HOME/code/cf/datalot/.datalot/bin"
fi

# Add asdf to PATH and source asdf
if [ -f "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" ]; then
  # shellcheck source=/dev/null
  . "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"
fi

# Add asdf paths
add_to_path "$USER_HOME/.asdf/bin" "$USER_HOME/.asdf/shims"

# Path to your Oh My Zsh installation.
export ZSH="$USER_HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
export ZSH_THEME="powerlevel10k/powerlevel10k"

# ---- Custom completions (must be before OMZ loads) ----
export DISABLE_COMPFIX=true
mkdir -p "$HOME/.zsh/completions"
fpath+=("$HOME/.zsh/completions")
# -------------------------------------------------------

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# shellcheck disable=SC2034,SC2039 # plugins is used by Oh My Zsh internally
plugins=() # Refer to ~/.zshrc.plugins

# Load Oh My Zsh
# shellcheck source=/dev/null
. "$ZSH/oh-my-zsh.sh"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
# alias are located in ~/.zshrc.local file

# Add SSH key to macOS keychain if it exists (Personal-specific)
if [ -f "$USER_HOME/.ssh/id_ed25519_centerfield" ]; then
  ssh-add --apple-use-keychain "$USER_HOME/.ssh/id_ed25519_centerfield" >/dev/null 2>&1
fi

# Source local configuration file
if [ -f "$USER_HOME/.zshrc.local" ]; then
  . "$USER_HOME/.zshrc.local"
fi

# Enable vi mode before prompt is drawn
bindkey -v

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
# shellcheck source=/dev/null
[[ -f "$USER_HOME/.p10k.zsh" ]] && source "$USER_HOME/.p10k.zsh"

# Load tiny AWS badge
[[ -f "$USER_HOME/.p10k-tiny-aws.zsh" ]] && source "$USER_HOME/.p10k-tiny-aws.zsh"
