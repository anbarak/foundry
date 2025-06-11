# shellcheck shell=bash
# =============================================================================
# AI Tooling (Ollama, Aider, LLM Wrappers)
# =============================================================================

LOG_DIR="$HOME/logs"
mkdir -p "$LOG_DIR"

# Root path for Foundry AI tools
AI_TOOLS="$HOME/bin/tools/ai"

# Load default model from ephemeral, XDG-compliant location
DEFAULT_MODEL_FILE="$HOME/.local/state/foundry/ollama-default-model"
mkdir -p "$(dirname "$DEFAULT_MODEL_FILE")"

if [[ -f "$DEFAULT_MODEL_FILE" ]]; then
  export OLLAMA_DEFAULT_MODEL="$(< "$DEFAULT_MODEL_FILE")"
else
  export OLLAMA_DEFAULT_MODEL="llama3.2"
fi
export AIDER_MODEL="$OLLAMA_DEFAULT_MODEL"

# Aider will default to this model unless overridden
export AIDER_MODEL="$OLLAMA_DEFAULT_MODEL"

# Wrapper to run local LLMs (default: $OLLAMA_DEFAULT_MODEL)
alias llm="$AI_TOOLS/foundry-llm.sh"

# Generate a conventional commit message from current git diff
alias commit-ai="$AI_TOOLS/commit-ai.sh"

# Health check for local Ollama server
alias ollama-health="$AI_TOOLS/healthcheck.sh"

# Optional: wrapper script to trigger AI-powered git commit
alias git-llm-commit="$AI_TOOLS/git-llm-commit"

# Optional: umbrella CLI dispatcher for AI tooling
alias aiwrap="$AI_TOOLS/foundry-ai-wrapper"

# Generate AI-assisted commit message for YADM-managed files
alias ycm-ai="$AI_TOOLS/yadm-llm-commit"

# Run Aider with default local model and options
alias aider-ai="$AI_TOOLS/aider-wrapper.sh"

# Use Aider to suggest commit message from git diff
alias aider-commit="$AI_TOOLS/aider-commit.sh"

# Run Ollama interactively with auto-update and model usage logging
ollama_run() {
  local model args
  if ollama list | awk 'NR>1 {print $1}' | grep -qFx "$1"; then
    model="$1"
    shift
    args=("$@")
  else
    model="$OLLAMA_DEFAULT_MODEL"
    args=("$@")
  fi

  echo "🔄 Checking latest model for: $model..."

  if ollama pull "$model" >> "$LOG_DIR/ollama-model-usage.log" 2>&1; then
    echo "✅ Model is up to date."
  else
    echo "⚠️ Failed to pull or update model: $model"
  fi

  echo "$(date +'%F %T') | ollama run $model ${args[*]}" >> "$LOG_DIR/ollama-model-usage.log"
  ollama run "$model" "${args[@]}"
}
alias ollamarun='ollama_run'

# FZF model picker that also persists selection
ollama_model_toggle() {
  local model_list="$HOME/.config/ollama/model-list.txt"
  local selected_model

  if [[ ! -s "$model_list" ]]; then
    echo "❌ No models found in $model_list"
    return 1
  fi

  selected_model=$(cat "$model_list" | fzf --prompt="Select Ollama model: ")
  if [[ -n "$selected_model" ]]; then
    export OLLAMA_DEFAULT_MODEL="$selected_model"
    echo "$selected_model" > "$DEFAULT_MODEL_FILE"
    echo "✅ Switched to model: $OLLAMA_DEFAULT_MODEL"
  else
    echo "❌ No model selected."
  fi
}
alias switch-model='ollama_model_toggle'

# Model utilities
alias ollama-models='ollama list | awk "NR>1 {print \$1}"'
alias ollama-models-fzf='ollama run "$(ollama-models | fzf)"'

# Quick AI health check
alias ai-selftest='ollama-health && ollamarun "Say hello"'

# Benchmark aliases
alias ai-benchmark="$AI_TOOLS/benchmark-wrap.sh"
alias ai-benchmark-fzf="$AI_TOOLS/benchmark-toggle.sh"
