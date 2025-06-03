#!/usr/bin/env bash
set -euo pipefail

echo "🔐 Restoring sensitive files from Bitwarden..."

BW_SESSION=$(/opt/homebrew/bin/bw unlock --raw)
export BW_SESSION

bw sync

# Sensitive archive
item_id=$(bw list items --search "Sensitive Config Files Backup" --session "$BW_SESSION" | jq -r '.[0].id')
bw get attachment "sensitive_config_files.tar.gz" \
  --itemid "$item_id" --session "$BW_SESSION" \
  --output ~/sensitive_config_files.tar.gz
tar -xzvf ~/sensitive_config_files.tar.gz -C ~
rm -f ~/sensitive_config_files.tar.gz

# Git config
git_item_id=$(bw list items --search "Git Config Backup" --session "$BW_SESSION" | jq -r '.[0].id')
mkdir -p ~/.config/git
bw get item "$git_item_id" --session "$BW_SESSION" | jq -r '.notes' | base64 --decode > ~/.config/git/config_local

echo "✅ Sensitive config and git config restored."
