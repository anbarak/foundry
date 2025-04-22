#!/usr/bin/env bash

segment_name="aws_profile"
segment_priority=10

print_segment() {
  profile="${AWS_PROFILE:-default}"
  echo "#[fg=cyan]AWS: $profile#[default]"
}

run_segment() {
  print_segment
  return 0
}
