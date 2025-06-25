#!/usr/bin/env bash
set -euo pipefail

# Determine interactivity *before* tee breaks stdout
IS_INTERACTIVE=false
if [[ -t 1 ]]; then
  IS_INTERACTIVE=true
fi

# Log setup (cron-friendly + interactive)
LOG_FILE="$HOME/logs/secrets-backup.log"
mkdir -p "$(dirname "$LOG_FILE")"

if [[ "$IS_INTERACTIVE" == true ]]; then
  exec > >(tee -a "$LOG_FILE") 2>&1
else
  exec >> "$LOG_FILE" 2>&1
fi

echo "[INFO] $(date +'%Y-%m-%d %H:%M:%S') Starting secrets backup..."

# ── Log truncation if file > 5MB ───────────────────────
LOG_MAX_MB=5
if [[ -f "$LOG_FILE" ]]; then
  size=$(du -m "$LOG_FILE" | cut -f1)
  if (( size > LOG_MAX_MB )); then
    log INFO "🧹 Truncating $LOG_FILE (was ${size}MB)"
    tail -n 200 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
  fi
fi

# Wrap the backup process to track success/failure
run_backup() {
  echo "📦 Creating secrets backup..."

  echo "🔐 Unlocking Bitwarden..."
  BW_MASTER_PASSWORD=$(security find-generic-password -s bitwarden -a master-password -w 2>/dev/null || true)
  if [[ -z "$BW_MASTER_PASSWORD" ]]; then
    echo "❌ Bitwarden master password not found in Keychain. Please run:"
    echo "$HOME/bin/tools/setup/save-bitwarden-master-password-to-keychain.sh"
    return 1
  fi

  export BW_SESSION
  BW_SESSION=$(bw unlock "$BW_MASTER_PASSWORD" --raw 2>/dev/null || true)
  if [[ -z "$BW_SESSION" ]]; then
    echo "❌ Failed to unlock Bitwarden with Keychain-stored password. Aborting..."
    return 1
  fi
  bw sync
  echo

  echo "📄 Backing up Jenkins hosts block to Bitwarden..."
  jenkins_block=$(cat "$HOME/.config/hosts/jenkins.block")

  jenkins_note_id=$(bw list items --search "Hosts – Jenkins Centerfield" --session "$BW_SESSION" | jq -r '.[0].id // empty')

  if [[ -z "$jenkins_note_id" ]]; then
    echo "➕ Creating new Bitwarden secure note..."
    bw get template item | \
      jq --arg name "Hosts – Jenkins Centerfield" \
         --arg notes "$jenkins_block" \
         '.
          | .type = 2
          | .secureNote.type = 0
          | .name = $name
          | .notes = $notes' | \
      bw encode | \
      bw create item --session "$BW_SESSION" >/dev/null
  else
    echo "♻️  Updating existing Bitwarden secure note..."
    bw get item "$jenkins_note_id" --session "$BW_SESSION" | \
      jq --arg notes "$jenkins_block" '.notes = $notes' | \
      bw encode | \
      bw edit item "$jenkins_note_id" --session "$BW_SESSION" >/dev/null
  fi

  # Define secrets to archive
  timestamp=$(date +"%Y%m%d-%H%M%S")
  backup_file="$HOME/sensitive_config_files-$timestamp.tar.gz"
  cd "$HOME"

  tar --exclude='.kube/cache' \
      --exclude='.aws/sso/cache' \
      --exclude='.aws/cli/cache' \
      --exclude='.gnupg/S.*' \
      --exclude='.gnupg/.gpg-connect_history' \
      --exclude='.gnupg/random_seed' \
      --exclude='.gnupg/private-keys-v1.d' \
      --exclude='.DS_Store' \
      --exclude='.ssh/known_hosts' \
      --exclude='*.lock' \
      --exclude='*.tmp' \
      --exclude='*.bak' \
      --exclude='*.[oO][lL][dD]*' \
      -czf "$backup_file" \
      .ssh .aws .saml2aws .kube .gnupg .vpn-configs \
      .gitconfig .gitconfig-centerfield .mysql \
      .mylogin.cnf

  echo "📤 Uploading to Bitwarden..."

  item_id=$(bw list items --search "Sensitive Config Files Backup" --session "$BW_SESSION" | jq -r '.[0].id')

  # Create item if missing
  if [[ -z "$item_id" || "$item_id" == "null" ]]; then
    folder_id=$(bw list folders --session "$BW_SESSION" | jq -r '.[] | select(.name=="Personal-work") | .id')
    item_id=$(bw get template item | \
      jq --arg name "Sensitive Config Files Backup" \
         --arg notes "Backup created on $(hostname) at $(date +'%Y-%m-%d %H:%M:%S %Z')" \
         --arg folder_id "$folder_id" \
         --arg upload_date "$(date +'%Y-%m-%d %H:%M:%S %Z')" \
         --arg archive_size "$(du -h "$backup_file" | cut -f1)" \
         --arg device "$(hostname)" \
      '.
        | .type = 2
        | .secureNote.type = 0
        | .name = $name
        | .notes = $notes
        | .folderId = $folder_id
        | .fields = [
            {name: "last-upload-date", value: $upload_date, type: 0},
            {name: "archive-size", value: $archive_size, type: 0},
            {name: "device", value: $device, type: 0}
          ]' | \
      bw encode | \
      bw create item --session "$BW_SESSION" | jq -r '.id')
  fi

  # Re-upload, keeping only the 3 most recent attachments
  echo "🧼 Checking for previous attachments to remove..."
  bw get item "$item_id" --session "$BW_SESSION" | \
    jq -r '.attachments | sort_by(.fileName) | reverse | .[3:][]?.id' | \
    while read -r old_id; do
      echo "🗑️  Removing old attachment ID: $old_id"
      bw delete attachment "$old_id" --itemid "$item_id" --session "$BW_SESSION"
    done

  bw create attachment --file "$backup_file" --itemid "$item_id" --session "$BW_SESSION"

  # Show backup location
  attachment_url=$(bw get item "$item_id" --session "$BW_SESSION" | jq -r '.attachments[0].url // "N/A"')
  echo "✅ Backup uploaded and saved in Bitwarden."
  echo "📁 Item: Sensitive Config Files Backup"
  echo "🌐 URL: $attachment_url"
  echo "🗃️  Folder: Personal-work"

  # Clean up local archive
  echo "🧹 Cleaning up local backup..."
  rm -f "$HOME/jenkins-hosts.block"
  rm -f "$backup_file"
}

# Run and report result
if run_backup; then
  $IS_INTERACTIVE && osascript -e 'display notification "✅ Secrets backup completed." with title "Bitwarden Backup"'
  if [[ "$IS_INTERACTIVE" == false ]]; then
    echo "[INFO] $(date +'%Y-%m-%d %H:%M:%S') Script exited with code: 0"
  fi

  # 📝 Record last successful run
  LABEL="$(basename "$0" .sh)"
  mkdir -p "$HOME/.cache/foundry"
  date +'%Y-%m-%d %H:%M:%S' > "$HOME/.cache/foundry/last-success-${LABEL}.txt"


  exit 0
else
  $IS_INTERACTIVE && osascript -e 'display notification "❌ Secrets backup failed!" with title "Bitwarden Backup" sound name "Funk"'
  if [[ "$IS_INTERACTIVE" == false ]]; then
    echo "[ERROR] $(date +'%Y-%m-%d %H:%M:%S') Script failed with code: $?"
  fi
  exit 1
fi
