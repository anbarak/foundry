#!/usr/bin/env bash
set -euo pipefail
log="${1:-init.log}"

grep -E "Downloading|- Installed" "$log" || echo "✅ No plugins installed or updated."
