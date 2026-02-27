#!/usr/bin/env bash
set -euo pipefail
version="${1:?Usage: tfxinit <version> [args...]}"
shift
echo "🚀 Initializing Terraform workspace..."
"$HOME/bin/tools/terraform/tfx-run.sh" "$version" init "$@"
