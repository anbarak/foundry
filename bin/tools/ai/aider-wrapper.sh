#!/usr/bin/env bash
# Wrapper to use aider with consistent model and options
set -euo pipefail

exec aider --model "${AIDER_MODEL:-codellama:7b}" "$@"
