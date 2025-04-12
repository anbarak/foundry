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
