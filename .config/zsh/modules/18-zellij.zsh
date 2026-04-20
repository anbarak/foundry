# shellcheck shell=bash
# =============================================================================
# Zellij — session management mirroring tmux aliases + domain shortcuts
# =============================================================================
# Prefix: 'zj' (because 'z' is taken by zoxide).
# Muscle memory: same 2-letter verbs as tmux, with 'zj' prefix.

# -----------------------------------------------------------------------------
# Core session commands
# -----------------------------------------------------------------------------
alias zjs='zellij attach --create'              # Smart attach/start (99% of the time) — like tmux `ts`
alias zja='zellij attach'                       # Attach to specific session — like tmux `ta`
alias zjn='zellij --session'                    # Create new named session — like tmux `tn`
alias zjks='zellij kill-session'                # Kill specific session — like tmux `tks`
alias zjka='zellij kill-all-sessions --yes'     # Kill all sessions — like tmux `tka`
alias zjl='zellij list-sessions'                # List all sessions — like tmux `tl`
alias zjd='zellij delete-all-sessions --yes'    # Delete all EXITED sessions (cleanup)
alias zjr='zellij action reload-layout && echo "Zellij layout reloaded ✅"'  # Reload layout

# -----------------------------------------------------------------------------
# Domain sessions — Platform Engineering workstreams
# -----------------------------------------------------------------------------
# Sessions are DOMAINS (stable for years), tabs are TICKETS (change weekly).
# One session per domain. Add new ones only when real work appears.
#
#   compute  → EKS, ArgoCD, Helm, k9s, workloads
#   data     → Aurora, RDS, MSK, OpenSearch, Snowflake
#   sec      → Security, compliance, identity, SSO, IAM
#   deliver  → CI/CD, deployments, IDW/Rally, CloudFormation
#   iac      → OpenTofu, Terraform, modules, provisioning
#   observe  → LGTM, Grafana, Loki, Datadog, alerts
#   hq       → Triage, Slack, one-offs, exploratory work
# -----------------------------------------------------------------------------
alias zjcom='zellij attach --create compute'
alias zjdat='zellij attach --create data'
alias zjsec='zellij attach --create sec'
alias zjdel='zellij attach --create deliver'
alias zjiac='zellij attach --create iac'
alias zjobs='zellij attach --create observe'
alias zjhq='zellij attach  --create hq'

# -----------------------------------------------------------------------------
# Convenience: session named after current directory (project-scoped work)
# -----------------------------------------------------------------------------
zjw() {
  local session_name="${PWD:t}"  # basename of current dir
  zellij attach --create "$session_name"
}
