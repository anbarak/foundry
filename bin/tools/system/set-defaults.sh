#!/usr/bin/env bash
set -euo pipefail

echo "🎯 Setting VLC as default for audio and video..."

DUTI_CONFIG="$HOME/.config/duti/defaults.duti"
if command -v duti &>/dev/null && [[ -f "$DUTI_CONFIG" ]]; then
  duti "$DUTI_CONFIG"
  echo "✅ Applied default app settings via duti."
else
  echo "⚠️ Either duti is not installed or $DUTI_CONFIG does not exist."
fi
