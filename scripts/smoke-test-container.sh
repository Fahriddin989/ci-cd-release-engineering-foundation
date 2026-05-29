#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

IMAGE_NAME="${IMAGE_NAME:-release-api}"
IMAGE_TAG="${IMAGE_TAG:-local}"
CONTAINER_NAME="${CONTAINER_NAME:-release-api-smoke}"
HOST_PORT="${HOST_PORT:-18000}"

cleanup() {
  docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true
}

cleanup
trap cleanup EXIT

docker run -d \
  --name "${CONTAINER_NAME}" \
  -p "${HOST_PORT}:8000" \
  -e APP_VERSION="${IMAGE_TAG}" \
  -e SERVICE_NAME="release-api" \
  "${IMAGE_NAME}:${IMAGE_TAG}" >/dev/null

for i in {1..20}; do
  if curl -fsS "http://127.0.0.1:${HOST_PORT}/health" >/dev/null 2>&1; then
    curl -s "http://127.0.0.1:${HOST_PORT}/health"
    echo
    exit 0
  fi

  sleep 1
done

echo "Smoke test failed: /health did not become ready"
docker logs "${CONTAINER_NAME}" || true
exit 1
