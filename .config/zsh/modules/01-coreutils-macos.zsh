# shellcheck shell=bash
# =============================================================================
# macOS-Specific Coreutils Overrides
# =============================================================================

# Only apply on macOS
[[ "$FOUNDRY_OS" != "macos" ]] && return 0

# macOS clipboard
alias pbcopy='pbcopy'
alias pbpaste='pbpaste'

# macOS audio playback
alias playlast='afplay "$(ls -t ~/recordings/*.wav | head -n1)"'

# macOS file opener
alias open='open'
