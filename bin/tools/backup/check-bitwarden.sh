#!/usr/bin/env bash
set -euo pipefail

echo "🔐 Checking Bitwarden session..."

if ! bw status | grep -q '"locked": false'; then
  echo "❌ Bitwarden CLI is not unlocked."
  exit 1
fi

echo "✅ Bitwarden CLI is unlocked and ready."
