#!/usr/bin/env bash

run_segment() {
  local window pane
  window=$(tmux display-message -p '#I')
  pane=$(tmux display-message -p '#P')

  echo "${window}.${pane}"
  return 0
}
