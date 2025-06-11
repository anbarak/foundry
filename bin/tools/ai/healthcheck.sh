#!/usr/bin/env bash
# Check if Ollama server is running
set -euo pipefail

curl -sf http://localhost:11434/api/tags >/dev/null \
  && echo "✅ Ollama is running" \
  || echo "❌ Ollama server not reachable"
