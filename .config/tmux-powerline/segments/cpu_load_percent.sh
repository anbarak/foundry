#!/usr/bin/env bash

print_segment() {
  load=$(sysctl -n vm.loadavg | awk -F'[{} ]' '{print $3}') # 1-minute load
  cores=$(sysctl -n hw.ncpu)
  load_percent=$(awk "BEGIN { printf \"%.1f\", ($load/$cores)*100 }")

  if [ "$load_percent" -lt 70 ]; then
    color="#[fg=green]"
    emoji="✅"
  elif [ "$load_percent" -le 100 ]; then
    color="#[fg=yellow]"
    emoji="⚠️"
  else
    color="#[fg=red]"
    emoji="🔥"
  fi

  echo "${color}🖥 CPU: ${load_percent}% $emoji#[default]"
}

run_segment() {
  print_segment
  return 0
}
