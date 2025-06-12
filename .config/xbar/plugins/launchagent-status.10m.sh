#!/bin/bash
# <xbar.title>LaunchAgent Status</xbar.title>
# <xbar.refreshTime>10m</xbar.refreshTime>
# <xbar.author>Hossein Aarabi</xbar.author>
# <xbar.desc>Show health and last run time of Foundry LaunchAgents</xbar.desc>

# 🛠️ Weekly Jobs
weekly_jobs=(
  restart-reminder-task
  brew-maintenance-task
  secrets-backup-task
  pipx-maintenance-task
  npm-maintenance-task
)
# 💻 Reboot Tasks
reboot_jobs=(
  install-ai-tools
)

echo "🛠️ Jobs"
echo "---"

BASE="$HOME/.cache/foundry"

show_status() {
  local label="$1"
  local file="$BASE/last-success-${label}.txt"
  local pretty
  pretty="$(pretty_label "$label")"

  if [[ -f "$file" ]]; then
    local time
    time=$(<"$file")

    # Time delta
    local mod_epoch now_epoch delta
    mod_epoch=$(stat -f "%m" "$file")      # last modified timestamp
    now_epoch=$(date +%s)
    delta=$((now_epoch - mod_epoch))

    # Human readable delta
    if ((delta < 60)); then
      ago="${delta}s ago"
    elif ((delta < 3600)); then
      ago="$((delta / 60))m ago"
    elif ((delta < 86400)); then
      ago="$((delta / 3600))h ago"
    else
      ago="$((delta / 86400))d ago"
    fi

    # Dynamic stale threshold: 2d for reboot jobs, 3d for weekly jobs
    local threshold=259200  # default: 3 days
    [[ "$label" == "install-ai-tools" ]] && threshold=172800  # 2 days

    if (( delta > threshold )); then
      echo "⚠️  Stale: Not run in $((delta / 86400)) days"
    fi

    echo "✅ $pretty | size=12"
    echo "↳ $ago ($time)"
  else
    echo "❌ $pretty | size=12"
    echo "↳ No run detected"
  fi
  echo "---"
}

pretty_label() {
  case "$1" in
    restart-reminder-task) echo "🔄 Restart Reminder (weekly)" ;;
    brew-maintenance-task) echo "🍺 Brew Maintenance (weekly)" ;;
    secrets-backup-task)   echo "🔐 Secrets Backup (weekly)" ;;
    pipx-maintenance-task) echo "🐍 pipx Maintenance (weekly)" ;;
    npm-maintenance-task)  echo "📦 npm Maintenance (weekly)" ;;
    install-ai-tools)      echo "🤖 Ollama Auto-Start (boot)" ;;
    *) echo "$1" ;;
  esac
}

echo "🛠️ Weekly Jobs"
echo "---"
for label in "${weekly_jobs[@]}"; do
  show_status "$label"
done

echo "💻 Reboot Tasks"
echo "---"
for label in "${reboot_jobs[@]}"; do
  show_status "$label"
done
