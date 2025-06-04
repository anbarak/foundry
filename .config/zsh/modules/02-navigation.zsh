# shellcheck shell=bash
# =============================================================================
# Navigation & Shortcuts
# =============================================================================
alias lc='gls -CF'                                                     # Classic column view (GNU ls)
alias l='eza -la --group-directories-first --git'                      # Long, all, git-aware, dirs first
alias lt='eza -laT --level=2 --group-directories-first --git'          # Tree view, level 2
alias lti='eza -laT --level=2 --group-directories-first --git --icons' # Tree view with icons
alias tree='tre'                                                       # Fast recursive tree (tre)
alias ftree='tre | fzf'                                                # Fuzzy search tree output
alias ldirs='eza -la --group-directories-first --only-dirs'            # Only directories
alias lfiles='eza -la --group-directories-first --only-files'          # Only files
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'
alias h='history'
alias rmf='trash -rf'
alias rmd='trash -d'
