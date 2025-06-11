#!/usr/bin/env bash
# shellcheck shell=bash
# Suggest a conventional commit message using aider and staged git diff
set -euo pipefail

exec aider --diff --message "Summarize these changes as a conventional commit message:"
