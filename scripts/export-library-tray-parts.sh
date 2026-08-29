#!/usr/bin/env bash
set -euo pipefail

if ! command -v openscad >/dev/null 2>&1; then
  echo "OpenSCAD is required. Install it, then rerun: make stl-tray" >&2
  exit 127
fi

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$project_dir/build/library-tray"
rm -rf -- "$out"
mkdir -p "$out"

parts=(behn_tray_face_a behn_tray_face_b behn_tray_core)
for part_name in "${parts[@]}"; do
  echo "Exporting $part_name for library FDM..."
  openscad \
    -o "$out/$part_name.stl" \
    -D 'preset="hecate946"' \
    -D 'print_profile="library_fdm"' \
    -D "part=\"$part_name\"" \
    "$project_dir/src/export.scad"
done

cat > "$out/PRINT_ME.txt" <<'TXT'
HECATE946 / Behn-style 5-reed tray prototype

PRINT THESE THREE STL FILES:
  1. behn_tray_face_a.stl
  2. behn_tray_face_b.stl
  3. behn_tray_core.stl

They assemble into ONE double-sided 10-reed tray.

Recommended orientation:
- face A: large flat perforated sheet on the bed; rails/walls facing UP
- face B: large flat perforated sheet on the bed; rails/walls facing UP
- core: flat on the bed exactly as exported
- supports: OFF

Prototype material: PLA is fine.
Suggested starting slicer settings for a 0.4 mm nozzle:
- 0.20 mm layer height
- 3 walls/perimeters
- 4 top/bottom layers
- 15-20% infill (the parts are mostly walls/sheets, so infill is not critical)
- no raft unless the library printer specifically needs one

Key nominal checks after printing:
- assembled tray body: 88.70 x 87.50 mm
- assembled thickness: 15.90 mm
- Boveda Size 8 opening: 71.85 x 5.10 mm
- magnet/steel pockets: 4.20 mm diameter x 2.15 mm deep for nominal 4 x 2 mm discs
- silicone retention grooves: for nominal 2.0 mm round silicone/O-ring material

Do NOT glue the tray before first test-fitting the Boveda pack.
TXT

echo
echo "Library tray STLs are ready in:"
echo "  $out"
echo "Copy that whole folder to your flash drive."
