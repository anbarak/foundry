#!/usr/bin/env bash
# Generate a conventional commit message using local LLM from git diff
set -euo pipefail

git diff | "$HOME/bin/tools/ai/foundry-llm.sh" codellama "Write a conventional commit message:"
