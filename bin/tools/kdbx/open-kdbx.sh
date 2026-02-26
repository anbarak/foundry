#!/usr/bin/env bash
set -euo pipefail

db_id="${1:-}"
if [[ -z "$db_id" ]]; then
  echo "Usage: open-kdbx <DBNAME>  (e.g. AWSDB)"
  exit 1
fi

# Map db_id to folder name
declare -A db_folders=(
  [AWSDB]="AWS"
  [GCPDB]="GCP"
  [NetEngDatabase]="NetEng"
  [ITOperationsDB]="SysEng"
  [QDPassDatabase]="SysEng"
  [3rdPartyVendors]="Third Party"
)

folder="${db_folders[$db_id]:-}"
if [[ -z "$folder" ]]; then
  echo "❌ Unknown database ID: $db_id"
  exit 1
fi

db_file="$HOME/OneDrive - Centerfield Media LLC/IT Infrastructure Documents/Access Credentials/$folder/$db_id.kdbx"

if [[ ! -f "$db_file" ]]; then
  echo "❌ File not found: $db_file"
  exit 1
fi

echo "🔐 Unlocking Bitwarden..."
BW_MASTER_PASSWORD=$(security find-generic-password -s bitwarden -a master-password -w 2>/dev/null || true)
if [[ -z "$BW_MASTER_PASSWORD" ]]; then
  echo "❌ Bitwarden master password not found in Keychain."
  exit 1
fi

export BW_SESSION
BW_SESSION=$(echo "$BW_MASTER_PASSWORD" | bw unlock --raw)

echo "📦 Getting password from Bitwarden..."
password=$(bw get password "KeePassXC Database ($db_id.kdbx)" --session "$BW_SESSION")
echo "$password" | tr -d '[:space:]' | pbcopy

echo "📋 Password copied to clipboard for 30 seconds."
open -a KeePassXC "$db_file"
(sleep 30 && pbcopy < /dev/null) & disown
