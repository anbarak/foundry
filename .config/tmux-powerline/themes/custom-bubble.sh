# shellcheck shell=bash disable=SC2034
# Custom Bubble Theme with Your Segments

# Gruvbox Dark Palette (bubble-style)
thm_bg="#282828"         # Dark0 (main background)
white="#ebdbb2"          # Light1 (text color everywhere)
red="#cc241d"            # Red
green="#98971a"          # Green
yellow="#d79921"         # Yellow
blue="#458588"           # Blue
purple="#b16286"         # Purple
aqua="#689d6a"           # Aqua
orange="#d65d0e"         # Orange
gray="#a89984"           # Light gray
gray_blue="#3c3836"      # Medium gray blue

# Separators (rounded "bubble" style)
TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
TMUX_POWERLINE_SEPARATOR_LEFT_THIN=""
TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
TMUX_POWERLINE_SEPARATOR_THIN="|"

# Default settings
TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-$thm_bg}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-$thm_fg}
TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}

if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_CURRENT" ]; then
  TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
    "#[$(format regular)]"
    "$TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR"
    "#[$(format inverse)]"
    " #I#F "
    "$TMUX_POWERLINE_SEPARATOR_THIN"
    " #W "
    "#[$(format regular)]"
    "$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
  )
fi

#if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_STYLE" ]; then
#  TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
#    "$(format regular)"
#  )
#fi

if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_FORMAT" ]; then
  TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
    "#[$(format regular)]"
    "  #I#{?window_flags,#F, } "
    "$TMUX_POWERLINE_SEPARATOR_THIN"
    " #W "
  )
fi

# ✅ LEFT SIDE
if [ -z "$TMUX_POWERLINE_LEFT_STATUS_SEGMENTS" ]; then
  TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
    "tmux_window_pane_info $gray_blue $white"
    "hostname $orange $white"
    "vpn $aqua $white"
    "vcs_branch_w_state_color $blue ''"
  )
fi

# ✅ RIGHT SIDE
if [ -z "$TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS" ]; then
  TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
    #"cpu_load_percent $yellow $white"
    #"memory $green $white"
    "time $purple $white"
    "utc_time $gray $white"
  )
fi
