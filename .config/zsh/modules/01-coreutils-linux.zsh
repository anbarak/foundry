# shellcheck shell=bash
# =============================================================================
# Linux-Specific Coreutils Overrides
# =============================================================================

# Only apply on Linux/WSL
[[ "$FOUNDRY_OS" == "macos" ]] && return 0

# Clipboard (X11)
if command -v xclip &>/dev/null; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
# Clipboard (Wayland)
elif command -v wl-copy &>/dev/null; then
  alias pbcopy='wl-copy'
  alias pbpaste='wl-paste'
# Clipboard (WSL)
elif command -v clip.exe &>/dev/null; then
  alias pbcopy='clip.exe'
  alias pbpaste='powershell.exe Get-Clipboard | tr -d "\r"'
fi

# Audio playback
if command -v mpv &>/dev/null; then
  alias playlast='mpv "$(ls -t ~/recordings/*.wav | head -n1)"'
elif command -v ffplay &>/dev/null; then
  alias playlast='ffplay -nodisp -autoexit "$(ls -t ~/recordings/*.wav | head -n1)"'
fi

# File opener
if command -v xdg-open &>/dev/null; then
  alias open='xdg-open'
fi
