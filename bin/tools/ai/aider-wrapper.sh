#!/usr/bin/env bash
# Wrapper to run Aider via Docker (under Colima) using local models
set -euo pipefail

MODEL="${AIDER_MODEL:-codellama:7b}"

if ! ollama list | grep -q "$MODEL"; then
  echo "❌ Required model '$MODEL' is not available in Ollama. Run: ollama pull $MODEL" >&2
  exit 1
fi

# Check if Colima is running
if ! colima status --json 2>/dev/null | jq -e '.docker_socket | test("docker.sock")' >/dev/null; then
  echo "❌ Colima is not running. Please start it first with: colima start" >&2
  exit 1
fi

exec docker run --rm -it \
  --user "$(id -u):$(id -g)" \
  -v "$(pwd):/app" \
  paulgauthier/aider-full \
  --model "$MODEL" \
  "$@"
