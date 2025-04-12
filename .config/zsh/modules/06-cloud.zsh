# shellcheck shell=bash
# =============================================================================
# Cloud Environment Switchers
# =============================================================================
alias aws-activate='switch-cloud aws'
alias gcp-activate='switch-cloud gcp'
alias azure-activate='switch-cloud azure'

switch-cloud() {
  local provider="${1:-}"
  local profile="${2:-centerfield}"

  case "$provider" in
    aws | gcp)
      [[ -f "$HOME/.config/clouds/load_all.sh" ]] \
        && source "$HOME/.config/clouds/load_all.sh" "$profile" \
        || echo "load_all.sh not found"
      export CLOUD="$provider"
      ;;
    azure)
      export CLOUD="azure"
      ;;
    *)
      echo "Unknown cloud provider: $provider"
      ;;
  esac
}
