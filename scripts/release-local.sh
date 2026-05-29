#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

IMAGE_NAME="${IMAGE_NAME:?Set IMAGE_NAME, for example ghcr.io/fahriddin989/ci-cd-release-engineering-foundation}"
IMAGE_TAG="${IMAGE_TAG:?Set IMAGE_TAG, for example v0.1.0}"

echo "Pulling release image: ${IMAGE_NAME}:${IMAGE_TAG}"
docker pull "${IMAGE_NAME}:${IMAGE_TAG}"

echo "Running release smoke test..."
IMAGE_NAME="${IMAGE_NAME}" \
IMAGE_TAG="${IMAGE_TAG}" \
CONTAINER_NAME="${CONTAINER_NAME:-release-api-local-validation}" \
HOST_PORT="${HOST_PORT:-18001}" \
./scripts/smoke-test-container.sh

echo "Release validation passed: ${IMAGE_NAME}:${IMAGE_TAG}"
