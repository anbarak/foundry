#!/usr/bin/env bash
# ~/bin/foundry/detect-os.sh

export FOUNDRY_OS="unknown"
export FOUNDRY_PKG_MANAGER="unknown"

if [[ "$OSTYPE" == "darwin"* ]]; then
  FOUNDRY_OS="macos"
  FOUNDRY_PKG_MANAGER="brew"

elif [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
  # Detect WSL specifically
  FOUNDRY_OS="wsl"

  if command -v apt-get &>/dev/null; then
    FOUNDRY_PKG_MANAGER="apt"
  elif command -v yum &>/dev/null; then
    FOUNDRY_PKG_MANAGER="yum"
  fi

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  FOUNDRY_OS="linux"

  # Detect distro
  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    case "$ID" in
      ubuntu|debian|pop) FOUNDRY_PKG_MANAGER="apt" ;;
      rhel|centos|fedora) FOUNDRY_PKG_MANAGER="yum" ;;
      arch|manjaro) FOUNDRY_PKG_MANAGER="pacman" ;;
    esac
  elif command -v apt-get &>/dev/null; then
    FOUNDRY_PKG_MANAGER="apt"
  elif command -v yum &>/dev/null; then
    FOUNDRY_PKG_MANAGER="yum"
  fi
fi

# Fallback: detect by available commands
if [[ "$FOUNDRY_PKG_MANAGER" == "unknown" ]]; then
  if command -v brew &>/dev/null; then
    FOUNDRY_PKG_MANAGER="brew"
  elif command -v apt-get &>/dev/null; then
    FOUNDRY_PKG_MANAGER="apt"
  elif command -v yum &>/dev/null; then
    FOUNDRY_PKG_MANAGER="yum"
  fi
fi
