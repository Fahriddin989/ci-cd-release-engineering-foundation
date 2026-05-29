#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

python3 -m venv .venv
source .venv/bin/activate

python -m pip install --upgrade pip
pip install -r app/backend/requirements.txt

python -m compileall app/backend
pytest -q
