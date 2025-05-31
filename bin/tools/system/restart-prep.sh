#!/bin/zsh
# restart-prep.sh – Safe weekly reboot prep script (non-destructive)

set -euo pipefail

# ====== Config ======
LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/restart-prep.log"
SCRIPT_NAME="$(basename "$0")"
TIMESTAMP="$(date "+%Y-%m-%d %H:%M:%S")"
NOTIFY_TITLE="🔄 Weekly Restart Reminder"
NOTIFY_MESSAGE="Restart your Mac to keep it fast, stable, and secure. A weekly reboot clears memory leaks, resets services, and applies system updates."

# ====== Setup ======
mkdir -p "$LOG_DIR"
echo "[$TIMESTAMP] [$SCRIPT_NAME] Starting restart prep..." >> "$LOG_FILE"

# ====== Docker Cleanup ======
if command -v docker &>/dev/null; then
  echo "[$TIMESTAMP] Stopping Docker containers..." >> "$LOG_FILE"
  docker ps -q | xargs -r docker stop >> "$LOG_FILE" 2>&1 || true
fi

# ====== Tmux Warning Only (Safe) ======
if command -v tmux &>/dev/null && tmux has-session 2>/dev/null; then
  echo "[$TIMESTAMP] Active tmux session(s) detected." >> "$LOG_FILE"
  osascript -e 'display notification "Active tmux sessions are running. Restart manually after closing them." with title "🔄 Restart Reminder (tmux)"'
else
  echo "[$TIMESTAMP] No tmux sessions found." >> "$LOG_FILE"
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
echo "[$TIMESTAMP] Restart reminder sent. Check $LOG_FILE for details."
