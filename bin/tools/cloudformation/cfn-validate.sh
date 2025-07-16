#!/usr/bin/env bash
set -euo pipefail

TEMPLATE="${1:-}"
if [[ -z "$TEMPLATE" || ! -f "$TEMPLATE" ]]; then
  echo "❌ Must provide a valid CloudFormation template file"
  exit 1
fi

echo "🔍 Running cfn-lint..."
cfn-lint -t "$TEMPLATE"

echo
echo "🔐 Running cfn-nag..."
cfn_nag_scan --input-path "$TEMPLATE"
