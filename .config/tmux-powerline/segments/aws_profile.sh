#!/usr/bin/env bash

print_segment() {
  profile="${AWS_PROFILE:-default}"

  # Attempt to get the identity (account/user/role)
  identity=$(aws sts get-caller-identity --query 'Arn' --output text 2>/dev/null)

  # Fallback if identity lookup fails
  if [ -z "$identity" ]; then
    identity="(not logged in)"
    color="#[fg=red]"
  else
    color="#[fg=cyan]"
    identity=$(basename "$identity") # Just show the last part: user or assumed-role
  fi

  echo "${color} AWS: $profile [$identity]#[default]"
}

run_segment() {
  print_segment
  return 0
}
