# shellcheck shell=bash
# ⚠️ These environment variables are used across modules.
# Do not remove unless you’ve verified downstream dependencies.
#
# =============================================================================
# Global Variables
# =============================================================================
export LOG_DIR="/var/log"
export AWS_CRED_HOME="$HOME/.aws"
export MY_CODE="$HOME/code/my"
export CF_CODE="$HOME/code/cf"

# =============================================================================
# OS Detection Variables (set by detect-os.sh)
# =============================================================================
export FOUNDRY_OS="${FOUNDRY_OS:-unknown}"           # macos, linux, wsl
export FOUNDRY_PKG_MANAGER="${FOUNDRY_PKG_MANAGER:-unknown}"  # brew, apt, yum
