#!/usr/bin/env bash
set -euo pipefail

file="${1:-plan.json}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print header
printf "${CYAN}%-10s %-40s %-30s %s${NC}\n" "ACTION" "TYPE" "NAME" "ADDRESS"
printf '%.0s─' {1..120}; echo

# Print rows with color
jq -r '.resource_changes[] | [.change.actions[0], .type, .name, .address] | @tsv' "$file" | \
while IFS=$'\t' read -r action type name address; do
  case "$action" in
    create)  color="$GREEN" ;;
    delete)  color="$RED" ;;
    update)  color="$YELLOW" ;;
    *)       color="$NC" ;;
  esac
  printf "${color}%-10s %-40s %-30s %s${NC}\n" "$action" "$type" "$name" "$address"
done

# Summary counts
echo
echo "Summary:"
jq -r '[.resource_changes[].change.actions[0]] | group_by(.) | map("\(.[0]): \(length)") | .[]' "$file" | \
while IFS=: read -r action count; do
  action=$(echo "$action" | xargs)
  count=$(echo "$count" | xargs)
  case "$action" in
    create)  printf "  ${GREEN}✚ %s: %s${NC}\n" "$action" "$count" ;;
    delete)  printf "  ${RED}✖ %s: %s${NC}\n" "$action" "$count" ;;
    update)  printf "  ${YELLOW}~ %s: %s${NC}\n" "$action" "$count" ;;
    *)       printf "  %s: %s\n" "$action" "$count" ;;
  esac
done
