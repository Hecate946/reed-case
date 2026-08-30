#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/reed-case-source.zip"

cd "$ROOT"
rm -f -- "$OUT"

zip -qr "$OUT" . \
  -x ".git/*" \
     ".git/**" \
     "build/*" \
     "build/**" \
     "*.stl" \
     "*.3mf" \
     "*.amf" \
     "*.csg" \
     "*.png" \
     "*.zip" \
     "*~" \
     "*.swp" \
     "*.tmp" \
     ".DS_Store"

printf 'Created %s\n' "$OUT"
