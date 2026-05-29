#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

IMAGE_NAME="${IMAGE_NAME:-release-api}"
IMAGE_TAG="${IMAGE_TAG:-$(./scripts/image-tag.sh)}"

docker build \
  --tag "${IMAGE_NAME}:${IMAGE_TAG}" \
  .
