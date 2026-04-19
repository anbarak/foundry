#!/usr/bin/env bash

# Enable or disable debug mode (shows errors for broken segments/themes)
export TMUX_POWERLINE_DEBUG_MODE_ENABLED="false"

# XDG configuration path (optional, but clean)
export XDG_CONFIG_HOME="$HOME/.config"

# Use your custom theme name (without `.sh` extension)
export TMUX_POWERLINE_THEME="custom-bubble"

# Path to your custom theme files
export TMUX_POWERLINE_DIR_USER_THEMES="$HOME/.config/tmux-powerline/themes"

# Path to your custom segments 
export TMUX_POWERLINE_DIR_USER_SEGMENTS="$HOME/.config/tmux-powerline/segments"
