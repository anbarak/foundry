#!/usr/bin/env bash
set -euo pipefail

echo "🔐 Restoring sensitive files from Bitwarden..."

# Unlock Bitwarden
BW_SESSION=$(/opt/homebrew/bin/bw unlock --raw)
export BW_SESSION

bw sync

# Download archive
item_id=$(bw list items --search "Sensitive Config Files Backup" --session "$BW_SESSION" | jq -r '.[0].id')
archive=~/sensitive_config_files.tar.gz

bw get attachment "sensitive_config_files.tar.gz" \
  --itemid "$item_id" --session "$BW_SESSION" \
  --output "$archive"


# 🔐 Validate checksum
echo "🔐 Verifying checksum..."
shasum -a 256 "$archive"

# ⚠️ Prompt before overwriting critical directories
exclude_flags=""
for dir in .ssh .aws .kube .gnupg .vpn-configs; do
  if [[ -e "$HOME/$dir" ]]; then
    read -r -p "⚠️  '$dir' already exists. Overwrite? (y/N): " confirm
    if [[ "$confirm" != "y" ]]; then
      echo "⏭️  Skipping $dir"
      exclude_flags+=" --exclude=$dir"
    fi
  fi
done

# Extract only selected content
tar -xzvf "$archive" -C ~ "$exclude_flags"

# Cleanup
rm -f "$archive"

# Restore Git config
git_item_id=$(bw list items --search "Git Config Backup" --session "$BW_SESSION" | jq -r '.[0].id')
mkdir -p ~/.config/git
bw get item "$git_item_id" --session "$BW_SESSION" | jq -r '.notes' | base64 --decode > ~/.config/git/config_local

# ♻️ Restart agents
echo "♻️ Restarting SSH and GPG agents..."
killall gpg-agent ssh-agent 2>/dev/null || true
eval "$(gpg-agent --daemon)" >/dev/null
eval "$(ssh-agent -s)" >/dev/null

echo "✅ Sensitive config and git config restored."
