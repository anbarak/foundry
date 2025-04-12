# shellcheck shell=bash
# =============================================================================
# Homebrew
# =============================================================================
alias brewup='brew update; brew upgrade; brew cleanup'

brewupdate() {
  local brewfile="$HOME/.config/homebrew/Brewfile"
  brew bundle dump --file="$brewfile" --force &&
  yadm add "$brewfile" &&
  yadm commit -m "Updated Brewfile" --no-gpg-sign &&
  yadm push
}

brewupall() {
  brewup
  echo "📦 Done updating. Do you want to update your Brewfile? (y/n)"
  read -r ans
  [[ $ans == y* ]] && brewupdate
}
