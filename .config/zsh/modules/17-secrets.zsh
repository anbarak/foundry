# ~/.config/zsh/modules/17-secrets.zsh

# Bitwarden unlock shortcut
alias bwun='export BW_SESSION=$(bw unlock --raw | tee "$HOME/.cache/bw-session")'
alias bwcheck='echo $BW_SESSION | cut -c1-8 && echo "… (session active)" || echo "❌ BW_SESSION is not set."'
alias bwlogout='unset BW_SESSION'

# Load cached BW_SESSION if available (no network call)
if [[ -z "$BW_SESSION" && -f "$HOME/.cache/bw-session" ]]; then
  export BW_SESSION=$(< "$HOME/.cache/bw-session")
fi

# Lazy-load Atlassian credentials only when needed
atlassian-init() {
  if [[ -n "$ATLASSIAN_TOKEN" ]]; then
    echo "✅ Already loaded."
    return 0
  fi
  if [[ -z "$BW_SESSION" ]]; then
    echo "❌ BW_SESSION not set. Run: bwun"
    return 1
  fi
  bw sync --session "$BW_SESSION" &>/dev/null
  if bw unlock --check --session "$BW_SESSION" &>/dev/null; then
    export ATLASSIAN_TOKEN=$(bw get password "Atlassian - haarabi-automation" --session "$BW_SESSION" 2>/dev/null)
    echo "✅ ATLASSIAN_TOKEN loaded."
  else
    echo "❌ Bitwarden session expired. Run: bwun"
    return 1
  fi
}

export ATLASSIAN_EMAIL="haarabi@centerfield.com"
export ATLASSIAN_URL="https://centerfieldmedia.atlassian.net"
