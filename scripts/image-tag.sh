#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

SHORT_SHA="$(git rev-parse --short HEAD)"

echo "sha-${SHORT_SHA}"
