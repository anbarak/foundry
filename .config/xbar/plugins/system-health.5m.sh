#!/bin/bash

# <xbar.title>System Health</xbar.title>
# <xbar.version>v1.3</xbar.version>
# <xbar.refreshTime>5m</xbar.refreshTime>
# <xbar.author>Hossein Aarabi</xbar.author>
# <xbar.desc>Shows RAM, disk, and battery health. Notifies on critical usage. Adapts icon colors based on thresholds and charging state.</xbar.desc>

notify() {
  osascript -e "display notification \"$1\" with title \"System Health\""
}

# 🧠 RAM USAGE
MEM_STATS=$(vm_stat)
PAGES_ACTIVE=$(echo "$MEM_STATS" | awk '/Pages active/ {gsub("\\.",""); print $3}')
PAGES_INACTIVE=$(echo "$MEM_STATS" | awk '/Pages inactive/ {gsub("\\.",""); print $3}')
PAGES_SPECULATIVE=$(echo "$MEM_STATS" | awk '/Pages speculative/ {gsub("\\.",""); print $3}')
PAGES_WIRED=$(echo "$MEM_STATS" | awk '/Pages wired down/ {gsub("\\.",""); print $4}')
PAGE_SIZE=$(sysctl -n hw.pagesize)
TOTAL_USED=$((PAGES_ACTIVE + PAGES_INACTIVE + PAGES_SPECULATIVE + PAGES_WIRED))
TOTAL_PAGES=$(($(sysctl -n hw.memsize) / PAGE_SIZE))
RAM_USAGE_PERCENT=$(awk "BEGIN { printf \"%.1f\", 100 * $TOTAL_USED / $TOTAL_PAGES }")

RAM_ICON="🧠"
if (( $(echo "$RAM_USAGE_PERCENT > 90" | bc -l) )); then
  RAM_ICON="⚠️🧠"
  notify "⚠️ RAM usage above 90% ($RAM_USAGE_PERCENT%)"
elif (( $(echo "$RAM_USAGE_PERCENT > 75" | bc -l) )); then
  RAM_ICON="🔸🧠"
fi

# 💾 DISK USAGE
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
DISK_VAL=${DISK_USAGE%\%}
DISK_ICON="💾"
if [[ $DISK_VAL -ge 90 ]]; then
  DISK_ICON="💾⚠️"
  notify "⚠️ Disk usage above 90% ($DISK_USAGE)"
elif [[ $DISK_VAL -ge 75 ]]; then
  DISK_ICON="💾🔸"
fi

# 🔋 BATTERY
BATTERY_INFO=$(pmset -g batt)
BATTERY_PERCENT=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | head -1)

HEALTH_INFO=$(system_profiler SPPowerDataType)
MAX_CAPACITY=$(echo "$HEALTH_INFO" | awk -F': ' '/Maximum Capacity/ {print $2}')
CONDITION=$(echo "$HEALTH_INFO" | awk -F': ' '/Condition/ {print $2}')
CYCLE_COUNT=$(echo "$HEALTH_INFO" | awk -F': ' '/Cycle Count/ {print $2}')

# Build battery health suffix
BATTERY_HEALTH=""
if [[ "$CONDITION" != "Normal" ]]; then
  BATTERY_HEALTH+=" | Condition: $CONDITION"
fi

if [[ "$CYCLE_COUNT" -ge 900 ]]; then
  BATTERY_HEALTH+=" | Cycles: $CYCLE_COUNT"
fi

# Choose battery icon
BATTERY_ICON="🔋"
if echo "$BATTERY_INFO" | grep -qi "AC Power"; then
  BATTERY_ICON="🔌🔋"
elif [[ ${BATTERY_PERCENT%\%} -le 20 ]]; then
  BATTERY_ICON="🔋⚠️"
elif [[ ${BATTERY_PERCENT%\%} -le 40 ]]; then
  BATTERY_ICON="🔋🔸"
fi

# --- Top bar summary ---
echo "$RAM_ICON $DISK_ICON $BATTERY_ICON"
echo "---"

# 🧠 RAM details
echo "$RAM_ICON RAM: $RAM_USAGE_PERCENT% used"

# 💾 Disk details
echo "$DISK_ICON Disk: $DISK_USAGE used"

# 🔋 Battery details
echo "$BATTERY_ICON Battery: $BATTERY_PERCENT ($MAX_CAPACITY)${BATTERY_HEALTH}"
