#!/usr/bin/env bash
# Generate a conventional commit message using local LLM from yadm diff
set -euo pipefail

yadm diff | "$HOME/bin/tools/ai/foundry-llm.sh" codellama "Write a conventional commit message for dotfile changes:"
