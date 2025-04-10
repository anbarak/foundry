# =============================================================================
# Kubernetes
# =============================================================================
alias kc='kubectl'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'
alias kget='kubectl get'
alias kdesc='kubectl describe'
alias klogs='kubectl logs'
alias kapply='kubectl apply -f'
alias kdel='kubectl delete -f'
alias kexec='kubectl exec -it'

# Containerized kubectl
alias k128='kubectl-container 1.28'
alias k129='kubectl-container 1.29'
alias k130='kubectl-container 1.30'
alias k131='kubectl-container 1.31'
alias k132='kubectl-container 1.32'

# Kubernetes helper tools
alias k9s='k9s'

eks-update-cluster() {
  if [[ -z "$1" ]]; then
    echo "Usage: eks-update-cluster <cluster-name>"
    return 1
  fi
  aws eks update-kubeconfig --name "$1" --region us-east-1
}

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

use-eks() {
  if [[ -z "$1" ]]; then
    echo "Usage: use-eks <cluster-name> [region]"
    return 1
  fi
  local REGION=${2:-us-east-1}
  aws eks update-kubeconfig --name "$1" --region "$REGION"
  echo "🔄 Now using EKS cluster: $1 in $REGION"
}
