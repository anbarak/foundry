#!/usr/bin/env bash
set -euo pipefail

echo "📌 Ensuring Jenkins hosts block is present in /etc/hosts..."

# Define marker to check for existing block
MARKER="# Jenkins Master Nodes"

if grep -qF "$MARKER" /etc/hosts; then
  echo "✅ Jenkins hosts block already present. Skipping."
  exit 0
fi

# Source: local file or Bitwarden fallback
if [[ -f ~/.config/hosts/jenkins.block ]]; then
  echo "📄 Found local Jenkins hosts block. Appending..."
  sudo tee -a /etc/hosts < ~/.config/hosts/jenkins.block >/dev/null
else
  echo "🛡️  Fetching Jenkins hosts block from Bitwarden..."

  BW_MASTER_PASSWORD=$(security find-generic-password -s bitwarden -a master-password -w 2>/dev/null || true)
  if [[ -z "$BW_MASTER_PASSWORD" ]]; then
    echo "❌ Bitwarden master password not found in Keychain."
    echo "   Please run: ~/bin/tools/setup/save-bitwarden-master-password-to-keychain.sh"
    exit 1
  fi

  export BW_SESSION=$(echo "$BW_MASTER_PASSWORD" | bw unlock --raw)
  bw get notes "Hosts – Jenkins Centerfield" > /tmp/jenkins.block

  sudo tee -a /etc/hosts < /tmp/jenkins.block >/dev/null
  rm -f /tmp/jenkins.block
fi

echo "✅ Jenkins hosts block successfully appended."
