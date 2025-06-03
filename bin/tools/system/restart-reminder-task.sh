#!/bin/zsh
# Safe weekly reboot prep script (non-destructive)

set -euo pipefail

# ====== Config ======
LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/restart-reminder.log"
SCRIPT_NAME="$(basename "$0")"
TIMESTAMP="$(date "+%Y-%m-%d %H:%M:%S")"
NOTIFY_TITLE="🔄 Weekly Restart Reminder"
NOTIFY_MESSAGE="Restart your Mac to keep it fast, stable, and secure. A weekly reboot clears memory leaks, resets services, and applies system updates."

# ====== Setup ======
mkdir -p "$LOG_DIR"
echo "[$TIMESTAMP] [$SCRIPT_NAME] Starting restart prep..." >> "$LOG_FILE"

# ====== Colima/Docker Cleanup ======
# Check if Colima was already running
colima_previously_running=false
if command -v colima &>/dev/null; then
  if colima status 2>/dev/null | grep -q "Running"; then
    colima_previously_running=true
    echo "[$TIMESTAMP] ✅ Colima already running." >> "$LOG_FILE"
  else
    echo "[$TIMESTAMP] ▶️ Starting Colima..." >> "$LOG_FILE"
    colima start >> "$LOG_FILE" 2>&1 || true
    sleep 2
  fi

  # Wait for Docker to become responsive (max 10 attempts)
  echo "[$TIMESTAMP] Waiting for Docker..." >> "$LOG_FILE"
  for i in {1..10}; do
    if docker info >/dev/null 2>&1; then
      echo "[$TIMESTAMP] ✅ Docker is ready." >> "$LOG_FILE"
      break
    fi
    echo "[$TIMESTAMP] ⏳ Docker not ready... retry $i" >> "$LOG_FILE"
    sleep 2
  done

  # Stop running containers
  if docker info >/dev/null 2>&1; then
    echo "[$TIMESTAMP] 🐳 Stopping Docker containers..." >> "$LOG_FILE"
    docker ps -q | xargs -r docker stop >> "$LOG_FILE" 2>&1 || true
  fi

  # Stop Colima only if we started it
  if [[ "$colima_previously_running" == false ]]; then
    echo "[$TIMESTAMP] ⏹️ Stopping Colima (was not running before)..." >> "$LOG_FILE"
    colima stop >> "$LOG_FILE" 2>&1 || true
  else
    echo "[$TIMESTAMP] 🔄 Colima left running (was already on)." >> "$LOG_FILE"
  fi
else
  echo "[$TIMESTAMP] ⚠️ Colima not installed — skipping Docker cleanup." >> "$LOG_FILE"
fi

# ====== Tmux Warning Only (Safe) ======
if command -v tmux &>/dev/null && tmux has-session 2>/dev/null; then
  echo "[$TIMESTAMP] ⚠️ Active tmux session(s) detected." >> "$LOG_FILE"
  osascript -e 'display notification "Active tmux sessions are running. Restart manually after closing them." with title "🔄 Restart Reminder (tmux)"'
else
  echo "[$TIMESTAMP] ✅ No tmux sessions found." >> "$LOG_FILE"
fi

# ====== System Snapshot ======
{
  echo ""
  echo "--- System Info Snapshot @ $TIMESTAMP ---"
  echo "• Uptime:"
  uptime
  echo ""
  echo "• Memory stats (vm_stat):"
  vm_stat
  echo ""
  echo "• Swap usage:"
  sysctl vm.swapusage
  echo ""
  echo "• Memory pressure:"
  echo "• Memory pressure:"
  if command -v memory_pressure >/dev/null; then
    memory_pressure | head -n 5
  else
    echo "memory_pressure not available"
  fi
  echo ""
  echo "• Disk usage (/):"
  df -h /
  echo "-----------------------------------------"
} >> "$LOG_FILE" 2>&1

# ====== Notification ======
osascript -e "display notification \"$NOTIFY_MESSAGE\" with title \"$NOTIFY_TITLE\""

# Optional stdout echo
echo "[$TIMESTAMP] ✅ Restart reminder sent. Check $LOG_FILE for details."
