#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

IMAGE_NAME="${IMAGE_NAME:-release-api}"
IMAGE_TAG="${IMAGE_TAG:-local}"

docker build \
  --tag "${IMAGE_NAME}:${IMAGE_TAG}" \
  .
