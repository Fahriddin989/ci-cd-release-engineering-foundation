#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

IMAGE_NAME="${IMAGE_NAME:?Set IMAGE_NAME, for example ghcr.io/fahriddin989/ci-cd-release-engineering-foundation}"
ROLLBACK_TAG="${ROLLBACK_TAG:?Set ROLLBACK_TAG, for example v0.1.0}"

echo "Rolling back locally to image:"
echo "${IMAGE_NAME}:${ROLLBACK_TAG}"

IMAGE_NAME="${IMAGE_NAME}" \
IMAGE_TAG="${ROLLBACK_TAG}" \
CONTAINER_NAME="${CONTAINER_NAME:-release-api-rollback-validation}" \
HOST_PORT="${HOST_PORT:-18002}" \
./scripts/release-local.sh

echo "Rollback validation passed:"
echo "${IMAGE_NAME}:${ROLLBACK_TAG}"
