# =============================================================================
# Homebrew
# =============================================================================
alias brewup='brew update; brew upgrade; brew cleanup'
alias brewupdate="brew bundle dump --file=~/.Brewfile --force && yadm add ~/.Brewfile && yadm commit -m \"Updated Brewfile\" && yadm push"
