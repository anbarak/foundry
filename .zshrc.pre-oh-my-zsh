# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
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

export HOMEBREW_PREFIX=$(brew --prefix)

# GNU coreutils paths - added at the beginning to take precedence
add_to_path "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"

# GNU findutils paths - added at the beginning to take precedence
add_to_path "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"

# Homebrew paths
if [[ -n "$HOMEBREW_PREFIX" ]]; then
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

# Apple security paths
add_to_path "/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin" \
            "/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin" \
            "/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin"

# Go paths
add_to_path "$USER_HOME/go/bin" "$HOMEBREW_PREFIX/opt/go/libexec/bin"

# Pyenv paths
add_to_path "$USER_HOME/.pyenv/plugins/pyenv-virtualenv/shims" "$USER_HOME/.pyenv/shims"

# Java paths
export JAVA_HOME="$HOMEBREW_PREFIX/opt/openjdk"
add_to_path "$JAVA_HOME/bin"

# Add krew path
add_to_path "$USER_HOME/.krew/bin"

if [[ -d "$USER_HOME/scripts" ]]; then
  add_to_path "$USER_HOME/scripts"
fi

if [[ -d "$USER_HOME/code/cf/datalot/.datalot" ]]; then
  add_to_path "$USER_HOME/code/cf/datalot/.datalot/bin"
fi  

# Add asdf to PATH and source asdf
if [ -f "$(brew --prefix)/opt/asdf/libexec/asdf.sh" ]; then
  . "$(brew --prefix)/opt/asdf/libexec/asdf.sh"
fi

# Add asdf paths
add_to_path "$HOME/.asdf/bin" "$HOME/.asdf/shims"

# Path to your Oh My Zsh installation.
export ZSH="$USER_HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

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
plugins=() # Refer to ~/.zshrc.plugins

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

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

# Add SSH key to macOS keychain
ssh-add --apple-use-keychain "$USER_HOME/.ssh/id_ed25519_centerfield" &>/dev/null

# Load pyenv automatically
if [[ -d "$USER_HOME/.pyenv" ]]; then
  add_to_path "$USER_HOME/.pyenv/bin"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Source local configuration file
if [ -f "$USER_HOME/.zshrc.local" ]; then
  source "$USER_HOME/.zshrc.local"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f "$USER_HOME/.p10k.zsh" ]] || source "$USER_HOME/.p10k.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
