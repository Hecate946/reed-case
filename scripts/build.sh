#!/usr/bin/env bash
set -euo pipefail

preset_name="${1:-hecate946}"
mode="${2:-case}"

case "$preset_name" in
  behn_premium20|size60_studio|hecate946) ;;
  *) echo "Unknown preset: $preset_name" >&2; exit 2 ;;
esac

case "$mode" in
  prototype|case|all) ;;
  *) echo "Unknown build mode: $mode (use prototype, case, or all)" >&2; exit 2 ;;
esac

if ! command -v openscad >/dev/null 2>&1; then
  echo "OpenSCAD is required. Install it, then rerun this command." >&2
  exit 127
fi

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="$project_dir/build/$preset_name"
mkdir -p "$output_dir"

if [[ "$mode" == "prototype" ]]; then
  # One complete current five-lane double-sided tray.
  parts=(behn_tray_face_a behn_tray_face_b behn_tray_core)
elif [[ "$mode" == "case" && "$preset_name" == "hecate946" ]]; then
  # HECATE946 shell plus a snap-hinge fit coupon. The tray STL is not duplicated:
  # print two copies of the existing tray set if you want both bays populated.
  parts=(hecate946_base hecate946_lid hecate946_hinge_coupon)
elif [[ "$mode" == "case" ]]; then
  parts=(base lid)
else
  if [[ "$preset_name" == "hecate946" ]]; then
    parts=(hecate946_base hecate946_lid hecate946_hinge_coupon behn_tray_face_a behn_tray_face_b behn_tray_core gasket_coupon tolerance_coupon)
  else
    parts=(base lid behn_tray_face_a behn_tray_face_b behn_tray_core hinge_pin latch_clip gasket_coupon tolerance_coupon)
  fi
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
