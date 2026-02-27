#!/usr/bin/env bash
set -euo pipefail
version="${1:?Usage: tfxvalidate <version> [args...]}"
shift
echo "🔎 Validating Terraform configuration..."
"$HOME/bin/tools/terraform/tfx-run.sh" "$version" validate "$@"
