#!/usr/bin/env bash
set -euo pipefail

# Paths
AI_DIR=~/bin/tools/ai
LOG_DIR=~/logs

MODE="${1:-interactive}"

# Determine if interactive session (user terminal) or not (LaunchAgent, cron, etc)
IS_INTERACTIVE=false
[[ -t 0 && "$MODE" != "non-interactive" ]] && IS_INTERACTIVE=true

# Prompt user before proceeding
if [[ "$MODE" == "non-interactive" ]]; then
  enable_ai="y"
elif read -rp \
  "🤖 Do you want to enable AI tooling (Ollama, local models, Aider)? [y/N]: " enable_ai \
  && [[ "$enable_ai" =~ ^[Yy]$ ]]; then
  :
else
  echo "🚫 Skipped AI tooling setup"
  exit 0
fi

if [[ "$enable_ai" =~ ^[Yy]$ ]]; then
  echo "🔧 Setting up AI tooling..."

  # Create folders
  mkdir -p "$AI_DIR" "$LOG_DIR"

  # Start Ollama server if not running
  if ! pgrep -f "ollama serve" >/dev/null 2>&1; then
    nohup /opt/homebrew/bin/ollama serve > "$LOG_DIR/ollama.log" 2>&1 &
    echo "✅ Started Ollama server in background"
  else
    echo "✅ Ollama server already running"
  fi

  # Determine which models to pull
  DEFAULT_MODEL_FILE="$HOME/.local/state/foundry/ollama-default-model"
  DEFAULT_MODEL=$(cat "$DEFAULT_MODEL_FILE" 2>/dev/null || echo llama3.2)

  echo "📦 Using default model only: $DEFAULT_MODEL"
  if ! ollama show "$DEFAULT_MODEL" >/dev/null 2>&1; then
    echo "⬇️  Pulling model: $DEFAULT_MODEL"
    ollama pull "$DEFAULT_MODEL"
  else
    echo "✅ Model already pulled: $DEFAULT_MODEL"
  fi

  # Install LaunchAgent to auto-start Ollama at login
  INSTALLER="$AI_DIR/install-ai-tools.sh"
  if [[ -x "$INSTALLER" ]]; then
    "$INSTALLER"
  fi

  if [[ "$IS_INTERACTIVE" == true ]]; then
    echo "📦 Ensuring Colima is running to pull aider Docker image..."

    COLIMA_STARTED=false
    if ! colima status | grep -q "Status: Running"; then
      echo "🚀 Starting Colima temporarily..."
      colima start
      COLIMA_STARTED=true
    else
      echo "✅ Colima already running"
    fi

    echo "📦 Pulling aider-full Docker image..."
    docker pull paulgauthier/aider-full

    if [[ "$COLIMA_STARTED" == true ]]; then
      echo "🛑 Stopping Colima (was started just for this task)..."
      colima stop
    fi
  else
    echo "⏭️ Skipping aider Docker pull in non-interactive mode"
  fi

else
  echo "🚫 Skipped AI tooling setup"
fi
