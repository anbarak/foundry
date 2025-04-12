# shellcheck shell=bash
# =============================================================================
# Kubernetes
# =============================================================================

# Local kubectl aliases
alias kc='kubectl'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'
alias kget='kubectl get'
alias kdesc='kubectl describe'
alias klogs='kubectl logs'
alias kapply='kubectl apply -f'
alias kdel='kubectl delete -f'
alias kexec='kubectl exec -it'

# Kubernetes TUI
alias k9s='k9s'

# -----------------------------------------------------------------------------
# Containerized kubectl (via runners/kubectl-container)
# -----------------------------------------------------------------------------

# Base alias pointing to your containerized runner
alias kcabzaar='"$HOME/bin/runners/kubectl-container"'
# Containerized kubectl helpersi
alias kc-versions='"$HOME/bin/runners/helpers/kubectl/kc-versions"'
alias kc-check='"$HOME/bin/runners/helpers/kubectl/kc-check"'
alias kc-plugins='"$HOME/bin/runners/helpers/kubectl/kc-plugins"'
alias kc-help='"$HOME/bin/runners/helpers/kubectl/kc-help"'

# Dynamic wrapper for any version of containerized kubectl
# Usage: kcx <version> [kubectl args...]
kcx() {
  if [[ -z "$1" ]]; then
    echo "Usage: kcx <version> [kubectl args...]"
    return 1
  fi
  local version="$1"; shift
  kcabzaar "$version" "$@"
}

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

# EKS update helper (defaults to us-east-1)
eks-update-cluster() {
  if [[ -z "$1" ]]; then
    echo "Usage: eks-update-cluster <cluster-name>"
    return 1
  fi
  aws eks update-kubeconfig --name "$1" --region us-east-1
}

# Describe all pods in a namespace
kdesc-all-pods() {
  if [[ -z "$1" ]]; then
    echo "Usage: kdesc-all-pods <namespace>"
    return 1
  fi
  for pod in $(kubectl get pods -n "$1" -o name); do
    echo "========== $pod =========="
    kubectl describe "$pod" -n "$1"
  done
}

# Switch EKS cluster with optional region (default: us-east-1)
use-eks() {
  if [[ -z "$1" ]]; then
    echo "Usage: use-eks <cluster-name> [region]"
    return 1
  fi
  local REGION=${2:-us-east-1}
  aws eks update-kubeconfig --name "$1" --region "$REGION"
  echo "🔄 Now using EKS cluster: $1 in $REGION"
}

