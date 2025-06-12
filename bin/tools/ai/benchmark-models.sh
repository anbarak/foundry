#!/usr/bin/env bash
set -euo pipefail

PROMPT_FILE="$HOME/benchmark-prompt.txt"
CSV_FILE="$HOME/logs/ollama-benchmark.csv"
DEFAULT_MODEL_FILE="$HOME/.local/state/foundry/ollama-default-model"
export OLLAMA_DEFAULT_MODEL="${OLLAMA_DEFAULT_MODEL:-$(cat "$DEFAULT_MODEL_FILE" 2>/dev/null || echo llama3.2)}"
mkdir -p "$HOME/logs" "$(dirname "$DEFAULT_MODEL_FILE")"

SKIP_SCORES=false
if [[ "${1:-}" == "--quick" ]]; then
  SKIP_SCORES=true
  shift
fi

available_models=$(ollama list | awk 'NR>1 {print $1}')
if [[ -z "$available_models" ]]; then
  echo "⚠️  No local Ollama models found. Use 'ollama pull ...' to add one."
  exit 1
fi

# Determine model selection
if [[ $# -ge 1 && ! -f "$1" ]]; then
  # Treat argument as a model name
  selected_models="$1"
else
  # Otherwise, show FZF selector
  selected_models=$(ollama list | awk 'NR>1 {print $1}' | fzf --multi --prompt="Select models to benchmark: ")
fi

if [[ -z "$selected_models" ]]; then
  echo "❌ No models selected."
  exit 1
fi


prompt=$(<"$PROMPT_FILE")

echo "🧪 Running benchmark on: $(uname -m) $(sysctl -n machdep.cpu.brand_string)"
echo "📄 Prompt: $prompt"
echo "──────────────────────────────"

if [[ ! -f "$CSV_FILE" ]]; then
  echo "timestamp,model,duration,correctness,clarity" > "$CSV_FILE"
fi

for model in $selected_models; do
  echo "🚀 Benchmarking $model"
  START=$(gdate +%s.%N)
  ollama run "$model" "$prompt"
  END=$(gdate +%s.%N)
  DURATION=$(echo "$END - $START" | bc)
  echo "⏱️  $model completed in ${DURATION}s"

  if [[ "$SKIP_SCORES" == false ]]; then
    # Score correctness with validation
    while [[ -z "${score_correctness:-}" || ! "$score_correctness" =~ ^[0-5]$ ]]; do
      read -rp "✅ Correctness score (0–5): " score_correctness
    done

    # Score clarity with validation
    while [[ -z "${score_clarity:-}" || ! "$score_clarity" =~ ^[0-5]$ ]]; do
      read -rp "✨ Clarity score (0–5): " score_clarity
    done
  else
    score_correctness=NA
    score_clarity=NA
  fi

  TIMESTAMP=$(date +'%F %T')

  # Log to CSV
  echo "$TIMESTAMP,$model,$DURATION,$score_correctness,$score_clarity" >> "$CSV_FILE"

  # Log with emoji summary
  echo "$TIMESTAMP | $model | ⏱️ ${DURATION}s | ✅ $score_correctness | ✨ $score_clarity | 📄 $prompt" \
    >> "$HOME/logs/ollama-benchmark-subjective.log"

  echo ""
done

# Optional: pin a model manually
read -rp "📌 Pin a model as default now? (leave blank to skip): " pin_model
if [[ -n "$pin_model" ]]; then
  pin_model=$(echo "$pin_model" | xargs)
  echo "$pin_model" > "$DEFAULT_MODEL_FILE"
  export OLLAMA_DEFAULT_MODEL="$pin_model"
  echo "✅ $pin_model pinned as default."
fi

# Auto-recommend best model by average score
read -rp "🤖 Auto-recommend best model based on scores? (y/n): " recommend
if [[ "$recommend" == "y" ]]; then
  best_model=$(awk -F, 'NR > 1 { sum[$2] += $4 + $5; count[$2]++ }
    END { for (m in sum) print m, sum[m]/count[m] }' "$CSV_FILE" | sort -k2 -nr | head -n1 | awk '{print $1}')
  if [[ -n "$best_model" ]]; then
    STATE_DIR="$HOME/.local/state/foundry"
    mkdir -p "$STATE_DIR"
    best_model=$(echo "$best_model" | xargs)
    echo "$best_model" > "$STATE_DIR/ollama-default-model"
    export OLLAMA_DEFAULT_MODEL="$best_model"
    echo "🏆 Auto-selected best model: $best_model"
    echo ""
    echo "📊 Top models:"
    awk -F, 'NR > 1 && $4 ~ /^[0-9]$/ && $5 ~ /^[0-9]$/ {
      score = $4 + $5;
      count[$2]++;
      total[$2] += score
    }
    END {
      for (m in total) {
        printf "%-20s %.2f\n", m, total[m] / count[m]
      }
    }' "$CSV_FILE" | sort -k2 -nr
  else
    echo "⚠️ Unable to determine best model."
  fi
fi
