#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Auditing SSH keys in ~/.ssh/keys..."

find ~/.ssh/keys -type f \( -name "*.pem" -o -name "*.ppk" \) | while read -r key; do
  echo "→ $(basename "$key") - $(stat -f "%z bytes, modified %Sm" "$key")"
done

echo "✅ Audit complete."
