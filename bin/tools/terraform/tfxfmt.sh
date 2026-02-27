#!/usr/bin/env bash
set -euo pipefail
version="${1:?Usage: tfxfmt <version> [args...]}"
shift
echo "🧹 Running Terraform fmt..."
"$HOME/bin/tools/terraform/tfx-run.sh" "$version" fmt "$@"
