# =============================================================================
# Centerfield-Specific Helpers
# =============================================================================

# EKS Cluster Login Shortcuts
login-redbird() {
  export AWS_PROFILE=insurance-main-sso
  export EKS_CLUSTER=exact-redbird-2020
  awslogin "$AWS_PROFILE"
}

login-manatee() {
  export AWS_PROFILE=insurance-consumer
  export EKS_CLUSTER=pumped-manatee
  awslogin "$AWS_PROFILE"
}

login-manatee-2020() {
  export AWS_PROFILE=insurance-consumer
  export EKS_CLUSTER=pumped-manatee-2020
  awslogin "$AWS_PROFILE"
}

login-hipaa() {
  export AWS_PROFILE=insurance-hipaa-prod-sso
  export EKS_CLUSTER=hipaa-prod-01
  awslogin "$AWS_PROFILE"
}
