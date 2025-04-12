# shellcheck shell=bash
# =============================================================================
# Networking
# =============================================================================
alias ip='ifconfig | grep "inet " | grep -v 127.0.0.1'
alias myip='ipconfig getifaddr en0'
alias myip_public='curl -s https://ifconfig.me'
alias myipall='ipconfig getifaddr en0 && ipconfig getifaddr en1'
alias ports='lsof -nP -iTCP -sTCP:LISTEN'
alias ping='ping -c 5'
alias netinfo='networksetup -listallhardwareports'
