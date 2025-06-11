#!/usr/bin/env bash
set -euo pipefail

# Paths
AI_DIR=~/bin/tools/ai
LOG_DIR=~/logs
WRAPPER="$AI_DIR/foundry-llm.sh"
ZSHRC_LOCAL=~/.zshrc.local

MODE="${1:-interactive}"

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

  # Pull Ollama models if missing
  MODEL_LIST_FILE="$HOME/.config/ollama/model-list.txt"
  if [[ -f "$MODEL_LIST_FILE" ]]; then
    mapfile -t models < "$MODEL_LIST_FILE"
  else
    models=(llama3.2)
  fi

  for model in "${models[@]}"; do
    if ! ollama show "$model" >/dev/null 2>&1; then
      echo "⬇️  Pulling model: $model"
      ollama pull "$model"
    else
      echo "✅ Model already pulled: $model"
    fi
  done

  # Install LaunchAgent to auto-start Ollama at login
  INSTALLER="$AI_DIR/install-ai-tools.sh"
  if [[ -x "$INSTALLER" ]]; then
    "$INSTALLER"
  fi

  # Create LLM wrapper
  cat <<'EOF' > "$WRAPPER"
#!/usr/bin/env bash
MODEL="${1:-$(<"$HOME/.local/state/foundry/ollama-default-model" 2>/dev/null || echo llama3.2)}"
shift
ollama run "$MODEL" "$@"
EOF

  chmod +x "$WRAPPER"

  # Add shell aliases if missing
  add_alias_if_missing() {
    local name="$1"
    local value="$2"
    grep -q "$name=" "$ZSHRC_LOCAL" 2>/dev/null || echo "alias $name=$value" >> "$ZSHRC_LOCAL"
  }

  add_alias_if_missing llm "'$WRAPPER'"
  add_alias_if_missing commit-ai "'git diff | llm codellama \"Write a conventional commit message:\"'"
  add_alias_if_missing ollama-health "'curl -s http://localhost:11434/version || echo \"Ollama server not running\"'"

  echo "✅ Aliases updated in $ZSHRC_LOCAL"

  # Ensure pipx and aider are installed
  if ! command -v aider &>/dev/null; then
    echo "📦 Installing aider-chat via pipx..."
    brew list pipx &>/dev/null || brew install pipx
    pipx install aider-chat
  else
    echo "✅ Aider already installed"
  fi

else
  echo "🚫 Skipped AI tooling setup"
fi
