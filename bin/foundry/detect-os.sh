#!/usr/bin/env bash
# ~/bin/foundry/detect-os.sh

export FOUNDRY_OS="unknown"
export FOUNDRY_PKG_MANAGER="unknown"

if [[ "$OSTYPE" == "darwin"* ]]; then
  FOUNDRY_OS="macos"
  FOUNDRY_PKG_MANAGER="brew"
elif [[ -f /etc/wsl.conf ]]; then
  FOUNDRY_OS="wsl"
  FOUNDRY_PKG_MANAGER="apt"  # or detect Ubuntu/Debian/etc.
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  FOUNDRY_OS="linux"
  # Detect apt/yum/pacman/etc.
  if command -v apt-get &>/dev/null; then
    FOUNDRY_PKG_MANAGER="apt"
  elif command -v yum &>/dev/null; then
    FOUNDRY_PKG_MANAGER="yum"
  fi
fi
