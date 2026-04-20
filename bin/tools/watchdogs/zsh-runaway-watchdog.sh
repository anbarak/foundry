#!/bin/bash
# zsh-runaway-watchdog.sh
#
# Detects and kills zsh processes that have been using >50% CPU for >10 minutes.
# Healthy interactive zsh uses ~0% CPU when idle — sustained high CPU means stuck
# in a widget loop or similar pathology.
#
# Invoked by launchd every 5 minutes via ~/Library/LaunchAgents/com.haarabi.zsh-runaway-watchdog.plist
#
# Logs to ~/Library/Logs/zsh-runaway-watchdog.log

set -u

LOG="$HOME/Library/Logs/zsh-runaway-watchdog.log"
mkdir -p "$(dirname "$LOG")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"
}

# Find zsh processes with %CPU > 50, owned by current user.
# Columns: PID %CPU elapsed-time command
# ps etime format: [[dd-]hh:]mm:ss  -- we want processes where elapsed > 10 min.

suspicious=$(ps -u "$USER" -o pid=,pcpu=,etime=,comm= | awk '
    $2 > 50 && $4 ~ /(\/|^)zsh$/ {
        # Parse etime into total seconds
        etime = $3
        # Formats: mm:ss, hh:mm:ss, dd-hh:mm:ss
        if (match(etime, /-/)) {
            split(etime, dhms, "-")
            days = dhms[1]
            rest = dhms[2]
        } else {
            days = 0
            rest = etime
        }
        n = split(rest, parts, ":")
        if (n == 2) { h = 0; m = parts[1]; s = parts[2] }
        else if (n == 3) { h = parts[1]; m = parts[2]; s = parts[3] }
        else { next }
        total = days*86400 + h*3600 + m*60 + s
        if (total > 600) print $1, $2, $3
    }
')

if [[ -z "$suspicious" ]]; then
    # Healthy state — no log entry to avoid log spam
    exit 0
fi

while IFS= read -r line; do
    pid=$(echo "$line" | awk '{print $1}')
    cpu=$(echo "$line" | awk '{print $2}')
    etime=$(echo "$line" | awk '{print $3}')
    
    # Get parent and cwd for forensic context
    ppid=$(ps -p "$pid" -o ppid= 2>/dev/null | tr -d ' ')
    cwd=$(lsof -p "$pid" 2>/dev/null | awk '$4 == "cwd" {print $NF; exit}')
    
    log "RUNAWAY: pid=$pid cpu=${cpu}% etime=$etime ppid=$ppid cwd=$cwd"
    
    # Send SIGTERM first, give it 2 seconds, then SIGKILL if still alive
    if kill "$pid" 2>/dev/null; then
        sleep 2
        if kill -0 "$pid" 2>/dev/null; then
            kill -9 "$pid" 2>/dev/null
            log "KILLED (SIGKILL): pid=$pid"
        else
            log "KILLED (SIGTERM): pid=$pid"
        fi
    else
        log "KILL FAILED: pid=$pid (already gone?)"
    fi
done <<< "$suspicious"
