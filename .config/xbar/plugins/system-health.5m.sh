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
PAGES_FREE=$(echo "$MEM_STATS" | awk '/Pages free/ {gsub("\\.",""); print $3}')
PAGES_ACTIVE=$(echo "$MEM_STATS" | awk '/Pages active/ {gsub("\\.",""); print $3}')
TOTAL=$((PAGES_FREE + PAGES_ACTIVE))
RAM_USAGE_PERCENT=$(awk "BEGIN { printf \"%.1f\", 100 * $PAGES_ACTIVE / $TOTAL }")

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
BATTERY_LEVEL=${BATTERY_PERCENT%\%}
BATTERY_MAH=$(ioreg -rc AppleSmartBattery 2>/dev/null | awk '/"CurrentCapacity"/ {cap=$3} /"MaxCapacity"/ {max=$3} END {if(cap && max) printf "(%s / %s mAh)", cap, max}')
BATTERY_CHARGING=$(echo "$BATTERY_INFO" | grep -i "AC Power")

BATTERY_ICON="🔋"
if [[ -z "$BATTERY_CHARGING" ]]; then
  if [[ $BATTERY_LEVEL -le 20 ]]; then
    BATTERY_ICON="🔋⚠️"
    notify "⚠️ Battery low: $BATTERY_PERCENT"
  elif [[ $BATTERY_LEVEL -le 40 ]]; then
    BATTERY_ICON="🔋🔸"
  fi
else
  BATTERY_ICON="🔌🔋"
fi

# --- Top bar summary ---
echo "$RAM_ICON $DISK_ICON $BATTERY_ICON"
echo "---"

# 🧠 RAM details
echo "$RAM_ICON RAM: $RAM_USAGE_PERCENT% used"

# 💾 Disk details
echo "$DISK_ICON Disk: $DISK_USAGE"

# 🔋 Battery details
echo "$BATTERY_ICON Battery: $BATTERY_PERCENT $BATTERY_MAH"
