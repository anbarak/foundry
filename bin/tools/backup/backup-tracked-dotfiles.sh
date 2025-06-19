#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# 📦 Backup all yadm-tracked dotfiles to ~/.foundry_backups/<timestamp>/
# Only non-secret, version-controlled files are backed up.
# -----------------------------------------------------------------------------

timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="$HOME/.foundry_backups/$timestamp"

echo "📦 Creating backup at: $backup_dir"
mkdir -p "$backup_dir"

cd "$HOME"

# Get list of yadm-tracked files
yadm ls-files | while read -r tracked_file; do
  src="$HOME/$tracked_file"
  dest="$backup_dir/$tracked_file"

  if [[ -e "$src" ]]; then
    mkdir -p "$(dirname "$dest")"
    cp -a "$src" "$dest"
    echo "✅ Backed up: $tracked_file"
  fi
done

echo ""
echo "🎉 Backup complete!"
echo "🗂️  Files saved to: $backup_dir"
echo "🧪 You can diff against it later using:"
echo "   diff -r $backup_dir \$HOME"
