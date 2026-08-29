#!/usr/bin/env bash
set -euo pipefail

preset_name="${1:-behn_premium20}"
mode="${2:-prototype}"

case "$preset_name" in
  behn_premium20|size60_studio) ;;
  *) echo "Unknown preset: $preset_name" >&2; exit 2 ;;
esac

case "$mode" in
  prototype|all) ;;
  *) echo "Unknown build mode: $mode (use prototype or all)" >&2; exit 2 ;;
esac

if ! command -v openscad >/dev/null 2>&1; then
  echo "OpenSCAD is required. Install it, then rerun this command." >&2
  exit 127
fi

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="$project_dir/build/$preset_name"
mkdir -p "$output_dir"

if [[ "$mode" == "prototype" ]]; then
  # Exactly one complete double-sided tray: one A face, one B face, one core.
  # These are deliberately separate printable parts; printing the assembled
  # tray monolithically would trap/require support inside the Boveda channel.
  parts=(behn_tray_face_a behn_tray_face_b behn_tray_core)
else
  parts=(base lid behn_tray_face_a behn_tray_face_b behn_tray_core hinge_pin latch_clip gasket_coupon tolerance_coupon)
fi

for part_name in "${parts[@]}"; do
  echo "Exporting $part_name ($preset_name)"
  openscad \
    -o "$output_dir/$part_name.stl" \
    -D "preset=\"$preset_name\"" \
    -D "part=\"$part_name\"" \
    "$project_dir/src/export.scad"
done

echo "STLs written to $output_dir"
