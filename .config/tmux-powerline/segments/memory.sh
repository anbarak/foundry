# shellcheck shell=bash
run_segment() {
  local mem_used mem_total mem_pct emoji

  mem_used=$(vm_stat | grep "Pages active" | awk '{print $3}' | tr -d '.')
  mem_total=$(sysctl -n hw.memsize)
  mem_total_pages=$((mem_total / 4096))

  if [ -z "$mem_used" ] || [ -z "$mem_total_pages" ]; then
    return
  fi

  mem_pct=$((100 * mem_used / mem_total_pages))

  if (( mem_pct <= 50 )); then
    emoji="🟢"
  elif (( mem_pct <= 75 )); then
    emoji="🟡"
  else
    emoji="🔴"
  fi

  echo "MEM: ${mem_pct}%${emoji}"
  return 0
}
