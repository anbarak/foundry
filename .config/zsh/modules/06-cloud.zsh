# =============================================================================
# Cloud Environment Switchers
# =============================================================================
alias aws-activate='switch-cloud aws'
alias gcp-activate='switch-cloud gcp'
alias azure-activate='switch-cloud azure'

switch-cloud() {
  case "$1" in
    aws)
      [[ -f $HOME/.config/clouds/aws.sh ]] && source $HOME/.config/clouds/aws.sh || echo "aws.sh not found"
      export CLOUD="aws"
      ;;
    gcp)
      [[ -f $HOME/.config/clouds/gcp.sh ]] && source $HOME/.config/clouds/gcp.sh || echo "gcp.sh not found"
      export CLOUD="gcp"
      ;;
    azure)
      export CLOUD="azure"
      ;;
    *)
      echo "Unknown cloud provider: $1"
      ;;
  esac
}
