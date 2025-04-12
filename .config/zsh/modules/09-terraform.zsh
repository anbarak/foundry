# =============================================================================
# Terraform (native local install)
# =============================================================================

alias tf='terraform'
alias tfa='terraform apply'
alias tfp='terraform plan'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tff='terraform fmt'
alias tfi='terraform init'
alias tfu='terraform state show'
alias tfw='terraform workspace'
alias tfw_list='terraform workspace list'
alias tfw_new='terraform workspace new'
alias tfw_select='terraform workspace select'

# Terraform helper tools
alias tfdoc='terraform-docs markdown table .'
alias tfl='tflint'
alias tfs='tfsec'

# =============================================================================
# Terraform (containerized)
# =============================================================================

# Native runner script
alias tfabzaar="~/bin/runners/terraform-container"

# Dynamic containerized Terraform command: usage -> tfx 1.6.6 plan
tfx() {
  if [[ -z "$1" ]]; then
    echo "Usage: tfx <terraform-version> [terraform-args...]"
    return 1
  fi
  local version="$1"; shift
  terraform-container "$version" "$@"
}

# Dynamic helpers
alias tf-versions="~/bin/runners/helpers/terraform/tf-versions"
alias tf-check="~/bin/runners/helpers/terraform/tf-check"
alias tf-help="~/bin/runners/helpers/terraform/tf-help"
