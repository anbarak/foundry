#!/usr/bin/env bash

get_cpu_load_percent() {
  local cores
  cores=$(sysctl -n hw.ncpu 2>/dev/null) || return 1

  local load
  load=$(uptime | awk -F'load averages?: ' '{print $2}' | cut -d',' -f1 | tr -d ' ') || return 1

  local percent
  percent=$(awk "BEGIN { printf \"%.0f\", ($load / $cores) * 100 }") || return 1

  echo "$percent"
}

print_segment() {
  local percent
  percent=$(get_cpu_load_percent)

  if [ -z "$percent" ]; then
    echo "󰍛 CPU: N/A"
    return
  fi

  local icon
  if [ "$percent" -lt 70 ]; then
    icon="🟢"
  elif [ "$percent" -lt 100 ]; then
    icon="🟡"
  else
    icon="🔴"
  fi

  echo "󰍛 CPU: ${percent}% ${icon}"
}

run_segment() {
  print_segment
  return 0
}
