# shellcheck shell=bash
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
alias tfdoc='terraform-docs markdown table .'
alias tfclean='rm -rf .terraform .terraform.lock.hcl tfplan.binary plan.json'

# Plan output shortcuts
alias tfplanbin='terraform plan -out=tfplan.binary'
alias tfplanjson='terraform show -json tfplan.binary | jq > plan.json'
alias tfshow='terraform show -no-color tfplan.binary'
alias tfbat='terraform show -no-color tfplan.binary | bat --language=hcl'

# Security + Lint
alias tfs='tfsec'
alias tfl='tflint'

# Containerized entrypoint
alias tfabzaar='"$HOME/bin/runners/terraform-container"'

# Dynamic containerized Terraform command: usage -> tfx 1.6.6 plan
tfx() {
	if [[ -z "$1" ]]; then
		echo "Usage: tfx <terraform-version> [terraform-args...]"
		return 1
	fi
	local version="$1"
	shift
	tfabzaar "$version" "$@"
}

# Containerized helpers
alias tf-versions="$HOME/bin/runners/helpers/terraform/tf-versions"
alias tf-check="$HOME/bin/runners/helpers/terraform/tf-check"
alias tf-help="$HOME/bin/runners/helpers/terraform/tf-help"

# Custom power tools
alias tfxplan="$HOME/bin/tools/terraform/tfxplan.sh"
alias tfxapply="$HOME/bin/tools/terraform/tfxapply.sh"
alias tfxdestroy="$HOME/bin/tools/terraform/tfxdestroy.sh"
alias tfxvalidate="$HOME/bin/tools/terraform/tfxvalidate.sh"
alias tfxinit="$HOME/bin/tools/terraform/tfxinit.sh"
alias tfxfmt="$HOME/bin/tools/terraform/tfxfmt.sh"
