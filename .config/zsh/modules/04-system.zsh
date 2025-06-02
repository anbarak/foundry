# shellcheck shell=bash
# =============================================================================
# System & Disk Utilities
# =============================================================================
alias update='sudo apt update && sudo apt upgrade -y'
alias df='df -h'
alias du1='du -h -d 1'
alias top='htop'
alias path='echo -e ${PATH//:/\\n}'
alias uptime='uptime'
alias brewdoctor='brew doctor'
alias diskl='diskutil list'
