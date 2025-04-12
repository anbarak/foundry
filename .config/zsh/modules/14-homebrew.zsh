# shellcheck shell=bash
# =============================================================================
# Homebrew
# =============================================================================
alias brewup='brew update; brew upgrade; brew cleanup'
alias brewupdate="brew bundle dump --file=$HOME/.config/homebrew/Brewfile --force && yadm add $HOME/.config/homebrew/Brewfile && yadm commit -m \"Updated Brewfile\" --no-gpg-sign && yadm push"
