# ~/.config/zsh/modules/17-secrets.zsh

# Bitwarden unlock shortcut
alias bwun='export BW_SESSION=$(bw unlock --raw | tee "$HOME/.cache/bw-session")'
alias bwcheck='echo $BW_SESSION | cut -c1-8 && echo "… (session active)" || echo "❌ BW_SESSION is not set."'
