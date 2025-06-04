# shellcheck shell=bash
# =============================================================================
# Cloud Environment Switchers
# =============================================================================
alias aws-activate='switch-cloud aws'
alias gcp-activate='switch-cloud gcp'
alias azure-activate='switch-cloud azure'

awsc() {
  echo "🔍 Current AWS Profile: $AWS_PROFILE"
  aws sts get-caller-identity
}

switch-cloud() {
	local provider="${1:-}"
	local profile="${2:-centerfield}"  # Default profile fallback

	case "$provider" in
	aws | gcp)
		local loader="$HOME/.config/clouds/load_all.sh"
		if [[ -f "$loader" && -x "$loader" && "$(command -v "$loader")" ]]; then
			source "$loader" "$profile"
		else
			echo "⚠️ $loader not found or not executable"
		fi
		export CLOUD="$provider"
		;;
	azure)
		export CLOUD="azure"
		;;
	*)
		echo "❌ Unknown cloud provider: $provider"
		;;
	esac
}

# ----------------------------------------
# VPN Connection Check
# ----------------------------------------
vpn_is_connected() {
  # Try standard utun check first
  if ifconfig | awk '
    BEGIN { found = 0 }
    /^[a-z0-9]+:/ { iface = $1 }
    iface ~ /^utun[0-9]+:$/ { utun = 1 }
    utun && $1 == "inet" && $2 ~ /^10\./ { found = 1 }
    /^[^[:space:]]/ { utun = 0 }
    END { exit found ? 0 : 1 }
  '; then
    return 0
  fi

  # Fallback: loop through utun interfaces with ipconfig
  for i in {0..9}; do
    if ipconfig getpacket utun$i 2>/dev/null | grep -q 'yiaddr ='; then
      return 0
    fi
  done

  return 1
}

# ----------------------------------------
# VPN Connect Logic
# ----------------------------------------
vpnconnect() {
  if vpn_is_connected; then
    echo "✅ VPN already connected."
    return
  fi

  echo "🔌 Opening AWS VPN Client..."
  echo "📋 Please manually select and connect to the correct VPN profile."
  open -a "AWS VPN Client"

  echo "⏳ Waiting for VPN to connect (press Ctrl+C to cancel)..."
  while true; do
    if vpn_is_connected; then
      echo "⏳ Waiting a few seconds for routing/DNS to stabilize..."
      sleep 4  # Grace period to ensure network is ready
      echo "✅ VPN successfully connected."
      return
    fi
    sleep 2
  done
}

# ----------------------------------------
# AWS SSO Login Helper
# ----------------------------------------
awslogin() {
  local profile="$1"

  # If no profile is provided, use fzf to prompt interactively
  if [[ -z "$profile" ]]; then
    profile=$(grep '^\[profile' ~/.aws/config | sed 's/\[profile //;s/\]//' | fzf --prompt="🔍 Select AWS profile: ") || return
  fi

  if [[ -z "$profile" ]]; then
    echo "❌ No AWS profile selected."
    return 1
  fi

  # Automatically launch VPN client if not connected
  vpnconnect || return 1

  echo "🔐 Logging in to AWS SSO profile: $profile"

  if ! aws sts get-caller-identity --profile "$profile" >/dev/null 2>&1; then
    aws sso login --profile "$profile" || {
      echo "❌ AWS SSO login failed"
      return 1
    }
  fi

  export AWS_PROFILE="$profile"
  echo "✅ AWS_PROFILE set to $profile"

  # Optional context switch if EKS_CLUSTER is set
  if [[ -n "$EKS_CLUSTER" ]]; then
    echo "🔄 Setting kubectl context to EKS cluster: $EKS_CLUSTER"
    aws eks update-kubeconfig --name "$EKS_CLUSTER" --region us-east-1 >/dev/null && \
      echo "✅ kubectl context set to $EKS_CLUSTER"
  fi
}

# ----------------------------------------
# 🔁 Auto-Renew AWS SSO Session
# ----------------------------------------
# - Refreshes session if less than 15 minutes left
# - Only runs once every 3 hours per profile
# - Skips if VPN is disconnected
# - Supports both new (sso_session) and legacy (sso_start_url) formats
# - Cleans expired token files
refresh_aws_sso() {
  local profile="${AWS_PROFILE:-}"
  [[ -z "$profile" ]] && return

  # Throttle: once every 3 hours
  local ts_file="$HOME/.cache/aws-sso-last-refresh-${profile}"
  mkdir -p "$(dirname "$ts_file")"
  local now=$(date +%s)
  local last_run=$(cat "$ts_file" 2>/dev/null || echo 0)
  (( now - last_run < 10800 )) && return
  echo "$now" > "$ts_file"

  # VPN required
  vpn_is_connected || return

  # Get start URL (modern or legacy)
  local session_name start_url
  session_name=$(aws configure get sso_session --profile "$profile" 2>/dev/null)
  if [[ -n "$session_name" ]]; then
    start_url=$(awk -v section="sso-session $session_name" '
      $0 ~ "\\[" section "\\]" {found=1; next}
      /^\[.*\]/ {found=0}
      found && $1 ~ /sso_start_url/ {print $3; exit}
    ' ~/.aws/config)
  else
    start_url=$(aws configure get sso_start_url --profile "$profile" 2>/dev/null)
  fi
  [[ -z "$start_url" ]] && return

  # Find cache file
  local cache_file
  cache_file=$(grep -l "\"startUrl\": \"$start_url\"" ~/.aws/sso/cache/*.json 2>/dev/null | head -n1)
  [[ -z "$cache_file" ]] && return

  # Check expiration
  local expires now_ts exp_secs left
  expires=$(jq -r '.expiresAt' "$cache_file")
  now_ts=$(date -u +%s)
  exp_secs=$(date -u -d "$expires" +%s 2>/dev/null || gdate -u -d "$expires" +%s)
  left=$((exp_secs - now_ts))

  # Refresh if expiring soon
  if (( left > 0 && left < 900 )); then
    echo "🔁 Refreshing AWS SSO session for $profile (expires in $((left / 60)) min)"
    aws sso login --profile "$profile" && \
      echo "✅ Refreshed $profile at $(date)" >> ~/.cache/aws-sso-refresh.log
  fi

  cleanup_old_sso_tokens
}

# ----------------------------------------
# 🧹 Clean Up Expired AWS SSO Tokens
# - Removes stale cache files from:
#   ~/.aws/sso/cache/      (SSO sessions)
#   ~/.aws/cli/cache/      (assumed roles, federated sessions)
# ----------------------------------------
cleanup_old_sso_tokens() {
  echo "🧹 Cleaning expired AWS SSO and CLI tokens..."

  for dir in ~/.aws/sso/cache ~/.aws/cli/cache; do
    [[ -d "$dir" ]] || continue
    find "$dir" -type f -name "*.json" | while read -r file; do
      local ts
      ts=$(jq -r '.expiresAt // .Expiration' "$file" 2>/dev/null) || continue
      local ts_epoch=$(date -u -d "$ts" +%s 2>/dev/null || gdate -u -d "$ts" +%s)
      local now_epoch=$(date -u +%s)

      if (( now_epoch > ts_epoch )); then
        echo "🧹 Removing expired token: $file"
        rm -f "$file"
      fi
    done
  done
}

# ----------------------------------------
# Aliases
# ----------------------------------------
alias okta="open https://centerfield.okta.com"
