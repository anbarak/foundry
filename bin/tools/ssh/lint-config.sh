#!/usr/bin/env bash
set -euo pipefail

echo "🧪 Validating SSH config..."

if ssh -G github.com >/dev/null 2>&1; then
  echo "✅ SSH config syntax is valid."
else
  echo "❌ SSH config validation failed."
  exit 1
fi
