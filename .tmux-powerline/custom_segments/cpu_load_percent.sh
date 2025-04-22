#!/usr/bin/env bash

# Segment name
segment_name="cpu_load_percent"
segment_priority=20

print_segment() {
  load=$(sysctl -n vm.loadavg | awk -F'[{} ]' '{print $3}')
  cores=$(sysctl -n hw.ncpu)
  load_percent=$(awk "BEGIN { printf \"%.0f\", ($load/$cores)*100 }")

  if [ "$load_percent" -lt 70 ]; then
    color="#[fg=green]"
  elif [ "$load_percent" -le 100 ]; then
    color="#[fg=yellow]"
  else
    color="#[fg=red]"
  fi

  echo "${color}CPU: ${load_percent}%#[default]"
}

run_segment() {
  print_segment
  return 0
}
