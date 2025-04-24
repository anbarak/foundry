# shellcheck shell=bash disable=SC2034
# Custom Bubble Theme with Your Segments (AWS, K8s, CPU, UTC, etc.)

# Catppuccin Macchiato Palette (bubble-style)
thm_bg="#24273A"
thm_fg="#c6d0f5"
eggplant="#e889d2"
sky_blue="#a7c7e7"
peach="#fab387"
blue="#89b4fa"
green="#a6e3a1"
teal="#94e2d5"
mauve="#cba6f7"
peach="#fab387"
surface0="#313244"
surface2="#cdd6f4"
dark_fg="#a5adce"
purple="#b4befe"
steel="#89b4fa"
aws_fg="#89b4fa"
k8s_fg="#b4befe"

TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
TMUX_POWERLINE_SEPARATOR_LEFT_THIN=""
TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
TMUX_POWERLINE_SEPARATOR_THIN="|"

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

if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_STYLE" ]; then
  TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
    "$(format regular)"
  )
fi

if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_FORMAT" ]; then
  TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
    "#[$(format regular)]"
    "  #I#{?window_flags,#F, } "
    "$TMUX_POWERLINE_SEPARATOR_THIN"
    " #W "
  )
fi

# ✅ LEFT SIDE: Session, hostname, VPN, Git branch
if [ -z "$TMUX_POWERLINE_LEFT_STATUS_SEGMENTS" ]; then
  TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
    "tmux_session_info $blue $thm_bg"
    "hostname $eggplant $thm_bg"
    "vpn $sky_blue $thm_bg ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}"
    "vcs_branch $peach $thm_bg "
  )
fi

# ✅ RIGHT SIDE: AWS, K8s, CPU, Time, UTC
if [ -z "$TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS" ]; then
  TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
    "aws_profile $aws_fg $thm_bg "
    "k8s_context $k8s_fg $thm_bg ⎈"
    "cpu_load_percent $teal $thm_bg 󰍛"
    "time $mauve $thm_bg ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN} 🕒"
    "utc_time $surface2 $thm_bg ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN} 🌍"
  )
fi
