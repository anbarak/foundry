# shellcheck shell=bash
# =============================================================================
# Homebrew (macOS only)
# =============================================================================

# Only load on macOS
if [[ "$FOUNDRY_OS" != "macos" ]]; then
  return 0
fi

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
