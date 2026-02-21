# ~/.config/zsh/modules/17-secrets.zsh

# Bitwarden unlock shortcut
alias bwun='export BW_SESSION=$(bw unlock --raw | tee "$HOME/.cache/bw-session")'
alias bwcheck='echo $BW_SESSION | cut -c1-8 && echo "… (session active)" || echo "❌ BW_SESSION is not set."'
alias bwlogout='unset BW_SESSION'

# Atlassian API
if command -v bw &>/dev/null; then
  if [[ -z "$BW_SESSION" && -f "$HOME/.cache/bw-session" ]]; then
    export BW_SESSION=$(cat "$HOME/.cache/bw-session")
  fi
  if [[ -n "$BW_SESSION" ]]; then
    export ATLASSIAN_TOKEN=$(bw get password "Atlassian - haarabi-automation" --session "$BW_SESSION" 2>/dev/null)
    export ATLASSIAN_EMAIL="haarabi@centerfield.com"
    export ATLASSIAN_URL="https://centerfieldmedia.atlassian.net"
  fi
fi
