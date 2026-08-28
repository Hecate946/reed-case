#!/usr/bin/env bash
set -euo pipefail

preset_name="${1:-behn_premium20}"
case "$preset_name" in
  behn_premium20|size60_studio) ;;
  *) echo "Unknown preset: $preset_name" >&2; exit 2 ;;
esac

if ! command -v openscad >/dev/null 2>&1; then
  echo "OpenSCAD is required. Install it, then rerun this command." >&2
  exit 127
fi

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="$project_dir/build/$preset_name"
mkdir -p "$output_dir"

parts=(base lid behn_tray_face behn_tray_core hinge_pin latch_clip gasket_coupon tolerance_coupon)
for part_name in "${parts[@]}"; do
  echo "Exporting $part_name ($preset_name)"
  openscad \
    -o "$output_dir/$part_name.stl" \
    -D "preset=\"$preset_name\"" \
    -D "part=\"$part_name\"" \
    "$project_dir/src/export.scad"
done

echo "STLs written to $output_dir"
