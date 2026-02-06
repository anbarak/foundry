#!/usr/bin/env bash
set -euo pipefail

# Load brew path helpers if present (macOS/Linuxbrew)
# so `ollama` can be resolved via PATH cross-platform.
if [[ -f "$HOME/bin/lib/ensure-brew-path.sh" ]]; then
  # shellcheck disable=SC1091
  source "$HOME/bin/lib/ensure-brew-path.sh"
fi

# Paths
AI_DIR="$HOME/bin/tools/ai"
LOG_DIR="$HOME/logs"

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

  # Ensure ollama exists in PATH
  if ! command -v ollama >/dev/null 2>&1; then
    echo "❌ ollama not found in PATH"
    echo "   Make sure Homebrew/Linuxbrew is installed and ensure-brew-path.sh is sourced."
    exit 1
  fi

  # Start Ollama server if not running
  if ! pgrep -f "ollama serve" >/dev/null 2>&1; then
    echo "🚀 Starting Ollama server..."
    nohup ollama serve > "$LOG_DIR/ollama.log" 2>&1 &

    # Wait for Ollama to be ready (max 30 seconds)
    echo "⏳ Waiting for Ollama server to start..."
    i=1
    while [[ "$i" -le 30 ]]; do
      if ollama list >/dev/null 2>&1; then
        echo "✅ Ollama server is ready"
        break
      fi
      sleep 1
      i=$((i + 1))
    done

    # Final check
    if ! ollama list >/dev/null 2>&1; then
      echo "❌ Ollama server failed to start. Check logs at $LOG_DIR/ollama.log"
      exit 1
    fi
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
