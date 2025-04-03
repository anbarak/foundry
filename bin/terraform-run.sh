#!/usr/bin/env bash
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <terraform-version> [terraform args...]"
  exit 1
fi

TF_VERSION="$1"
shift

docker run --rm -it \
  -v "$PWD":/infra \
  -w /infra \
  --platform linux/amd64 \
  devopscloudycontainers/terraform-abzaar:"$TF_VERSION" "$@"
