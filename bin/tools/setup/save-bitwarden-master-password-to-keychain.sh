#!/usr/bin/env bash
set -euo pipefail

echo "🔐 Saving Bitwarden master password to macOS Keychain..."

SERVICE="bitwarden"
ACCOUNT="master-password"
SECURITY_CMD=$(command -v security)

if [[ -z "$SECURITY_CMD" ]]; then
  echo "❌ 'security' command not found. This script must be run on macOS."
  exit 1
fi

# Prompt user securely
read -s -p "Enter your Bitwarden master password: " BW_MASTER_PASSWORD
echo

# Save to Keychain
security add-generic-password -a "$ACCOUNT" -s "$SERVICE" -w "$BW_MASTER_PASSWORD" -U

echo "✅ Bitwarden master password saved securely to Keychain."
