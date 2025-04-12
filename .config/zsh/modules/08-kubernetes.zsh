# =============================================================================
# Kubernetes (native kubectl)
# =============================================================================

alias kc='kubectl'                                           # shorthand for kubectl
alias kctl='kubectl'                                         # native kubectl (explicit)
alias kctx='kubectl config use-context'                      # switch context
alias kns='kubectl config set-context --current --namespace' # change namespace
alias kget='kubectl get'
alias kdesc='kubectl describe'
alias klogs='kubectl logs'
alias kapply='kubectl apply -f'
alias kdel='kubectl delete -f'
alias kexec='kubectl exec -it'
alias k9s='k9s'

# =============================================================================
# Kubernetes (containerized kubectl)
# =============================================================================

alias kct='kubectl-container'  # containerized runner shortcut

# Dynamic containerized kubectl command: usage -> kcx 1.30 get pods
kcx() {
  if [[ -z "$1" ]]; then
    echo "Usage: kcx <kubectl-version> [kubectl-args...]"
    return 1
  fi
  local version="$1"; shift
  kubectl-container "$version" "$@"
}

# =============================================================================
# Kubernetes Utility Functions
# =============================================================================

# Update kubeconfig for EKS
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

# Switch EKS cluster context
use-eks() {
  if [[ -z "$1" ]]; then
    echo "Usage: use-eks <cluster-name> [region]"
    return 1
  fi
  local REGION=${2:-us-east-1}
  aws eks update-kubeconfig --name "$1" --region "$REGION"
  echo "🔄 Now using EKS cluster: $1 in $REGION"
}

# =============================================================================
# Kubernetes Helpers (runner scripts)
# =============================================================================

alias kc-versions="~/bin/runners/helpers/kubectl/kc-versions"
alias kc-check="~/bin/runners/helpers/kubectl/kc-check"
alias kc-plugins="~/bin/runners/helpers/kubectl/kc-plugins"
alias kc-help="~/bin/runners/helpers/kubectl/kc-help"
