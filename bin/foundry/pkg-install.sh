#!/usr/bin/env bash
# ~/bin/foundry/pkg-install.sh <package1> <package2> ...

source "$HOME/bin/foundry/detect-os.sh"

case "$FOUNDRY_PKG_MANAGER" in
  brew)
    brew install "$@"
    ;;
  apt)
    sudo apt-get update && sudo apt-get install -y "$@"
    ;;
  yum)
    sudo yum install -y "$@"
    ;;
  *)
    echo "⚠️  Unknown package manager: $FOUNDRY_PKG_MANAGER"
    exit 1
    ;;
esac
