#!/bin/bash
set -euo pipefail

# Ensure librespeed-cli is installed
if [[ ! -x "$HOME/.local/bin/tools/librespeed-cli" ]]; then
  "$HOME/bin/tools/system/setup-librespeed.sh"
fi

echo "Running speed test with librespeed-cli..."
"$HOME/.local/bin/tools/librespeed-cli" --simple --telemetry-level=disabled
