#!/usr/bin/env bash
MODEL="${1:-$(<"$HOME/.local/state/foundry/ollama-default-model" 2>/dev/null || echo llama3.2)}"
shift
ollama run "$MODEL" "$@"
