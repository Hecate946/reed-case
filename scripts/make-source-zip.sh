#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_NAME="$(basename "$ROOT")"
STAMP="$(date +"%Y%m%d-%H%M%S")"
OUT="$ROOT/${PROJECT_NAME}-source-${STAMP}.zip"

cd "$ROOT"

zip -r "$OUT" . \
  -x ".git/*" \
     ".git/**" \
     ".vscode/*" \
     ".vscode/**" \
     "exports/*" \
     "exports/**" \
     "*.stl" \
     "*.3mf" \
     "*.amf" \
     "*.off" \
     "*.zip" \
     "*~" \
     "*.swp" \
     "*.tmp" \
     ".DS_Store"

echo
echo "Created:"
echo "$OUT"