# shellcheck shell=bash
# =============================================================================
# Log File Viewing
# =============================================================================
alias tailf='tail -f'
alias tail100='tail -n 100'
alias tail200='tail -n 200'
alias tail500='tail -n 500'
alias tail1k='tail -n 1000'
alias tail2k='tail -n 2000'
alias tailf100='tail -f -n 100'
alias tailf200='tail -f -n 200'
alias tailf500='tail -f -n 500'
alias tailf1k='tail -f -n 1000'
alias tailf2k='tail -f -n 2000'

taillog() {
	if [[ -z "$1" ]]; then
		echo "Usage: taillog <filename>"
		return 1
	fi
	tail -f "$LOG_DIR/$1"
}

logsince() {
  if (( $# < 2 )); then
    echo "Usage: logsince <YYYY-MM-DD> <logfile>"
    return 1
  fi

  local date="$1"
  local file="$2"
  [[ -f "$file" ]] || { echo "❌ File not found: $file"; return 2; }

  # Find the first matching line with a date ≥ $date
  local match
  match=$(grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' "$file" | sort -u | awk -v d="$date" '$0 >= d { print; exit }')

  if [[ -z "$match" ]]; then
    echo "⚠️ No entries on or after $date found in $file"
    return 0
  fi

  # Show log from the first matching date onward
  sed -n "/$match/,\$p" "$file" | {
    if command -v bat &>/dev/null; then
      bat --language=log --paging=never
    else
      cat
    fi
  }
}
