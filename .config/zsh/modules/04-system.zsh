# shellcheck shell=bash
# =============================================================================
# System & Disk Utilities
# =============================================================================

# Platform-specific update commands
if [[ "$FOUNDRY_OS" == "macos" ]]; then
  alias update='brew update && brew upgrade'
  alias brewdoctor='brew doctor'
  alias diskl='diskutil list'
elif command -v apt-get &>/dev/null; then
  alias update='sudo apt update && sudo apt upgrade -y'
elif command -v yum &>/dev/null; then
  alias update='sudo yum update -y'
fi

# Universal aliases
alias df='df -h'
alias du1='du -h -d 1'
alias top='htop'
alias path='echo -e ${PATH//:/\\n}'
alias uptime='uptime'
