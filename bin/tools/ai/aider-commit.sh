#!/usr/bin/env bash
# Suggest a conventional commit message using Docker-based Aider
set -euo pipefail

exec "$AI_TOOLS/aider-wrapper.sh" --diff --message "Summarize these changes as a conventional commit message:"
