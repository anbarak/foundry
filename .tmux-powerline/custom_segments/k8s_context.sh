#!/usr/bin/env bash

segment_name="k8s_context"
segment_priority=15

print_segment() {
  context=$(kubectl config current-context 2>/dev/null)
  namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
  echo "#[fg=magenta]K8s: ${context:-none}/${namespace:-default}#[default]"
}

run_segment() {
  print_segment
  return 0
}
