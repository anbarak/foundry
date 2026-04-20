#!/usr/bin/env bash
# zsh-runaway-watchdog-task.sh
#
# Detects and kills zsh processes that have been using >50% CPU for >10 minutes.
# Healthy interactive zsh uses ~0% CPU when idle — sustained high CPU means
# stuck in a widget loop or similar pathology.
#
# Invoked by launchd every 5 minutes via
# ~/Library/LaunchAgents/com.user.zsh-runaway-watchdog.plist
#
# Installed by: install-zsh-runaway-watchdog.sh
# Logs to:      ~/logs/zsh-runaway-watchdog.log

set -euo pipefail

LOG_FILE="$HOME/logs/zsh-runaway-watchdog.log"
mkdir -p "$(dirname "$LOG_FILE")"

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
log() { local level="$1"; shift; printf '[%s] %s %s\n' "$level" "$(timestamp)" "$*" >> "$LOG_FILE"; }

# Thresholds (tunable)
CPU_THRESHOLD=50        # percent
ELAPSED_THRESHOLD=600   # seconds (10 minutes)

# Find zsh processes owned by $USER using >CPU_THRESHOLD% CPU.
# Parse etime (elapsed time) to filter those running >ELAPSED_THRESHOLD seconds.
# etime formats: mm:ss, hh:mm:ss, dd-hh:mm:ss
suspicious=$(ps -u "$USER" -o pid=,pcpu=,etime=,comm= | awk -v cpu="$CPU_THRESHOLD" -v thresh="$ELAPSED_THRESHOLD" '
    $2 > cpu && $4 ~ /(\/|^)zsh$/ {
        etime = $3
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
        if (total > thresh) print $1, $2, $3
    }
')

if [[ -z "$suspicious" ]]; then
    # Healthy state — no log entry to avoid log spam
    exit 0
fi

while IFS= read -r line; do
    pid=$(awk '{print $1}' <<< "$line")
    cpu=$(awk '{print $2}' <<< "$line")
    etime=$(awk '{print $3}' <<< "$line")

    # Forensic context — capture before killing
    ppid=$(ps -p "$pid" -o ppid= 2>/dev/null | tr -d ' ' || true)
    cwd=$(lsof -p "$pid" 2>/dev/null | awk '$4 == "cwd" {print $NF; exit}' || true)

    log WARN "RUNAWAY detected: pid=$pid cpu=${cpu}% etime=$etime ppid=${ppid:-unknown} cwd=${cwd:-unknown}"

    # SIGTERM first, give it 2 seconds, then SIGKILL if still alive
    if kill "$pid" 2>/dev/null; then
        sleep 2
        if kill -0 "$pid" 2>/dev/null; then
            kill -9 "$pid" 2>/dev/null && log INFO "KILLED (SIGKILL): pid=$pid"
        else
            log INFO "KILLED (SIGTERM): pid=$pid"
        fi
    else
        log ERROR "KILL FAILED: pid=$pid (already gone?)"
    fi
done <<< "$suspicious"
