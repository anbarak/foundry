export TMUX_POWERLINE_DEBUG_MODE_ENABLED="false"
export TMUX_POWERLINE_THEME="custom-bubble"
export TMUX_POWERLINE_DIR_USER_SEGMENTS="$HOME/.config/tmux-powerline/segments"

source_if_exists "$TMUX_POWERLINE_DIR_USER_SEGMENTS/aws_profile.sh"
source_if_exists "$TMUX_POWERLINE_DIR_USER_SEGMENTS/k8s_context.sh"
source_if_exists "$TMUX_POWERLINE_DIR_USER_SEGMENTS/cpu_load_percent.sh"
source_if_exists "$TMUX_POWERLINE_DIR_USER_SEGMENTS/utc_time.sh"
