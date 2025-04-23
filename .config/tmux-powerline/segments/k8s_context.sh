#!/usr/bin/env bash

print_segment() {
  context=$(kubectl config current-context 2>/dev/null)
  namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)

  if [ -n "$context" ]; then
    echo "#[fg=magenta]⎈ K8s: ${context}/${namespace:-default}#[default]"
  else
    echo "#[fg=grey]⎈ K8s: not set#[default]"
  fi
}

run_segment() {
  print_segment
  return 0
}
