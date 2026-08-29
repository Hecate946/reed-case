#!/usr/bin/env bash
set -euo pipefail

if ! command -v openscad >/dev/null 2>&1; then
  echo "OpenSCAD is required. Install it, then rerun: make stl-tray" >&2
  exit 127
fi

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$project_dir/build/library-tray-one-piece"
stl="$out/behn_tray_ONE_PIECE.stl"
log="$out/openscad-export.log"
rm -rf -- "$out"
mkdir -p "$out"

echo "Exporting one Boolean-unioned Behn tray STL..."
echo "(OpenSCAD CGAL render may take about 1-3 minutes.)"

# IMPORTANT: export the actual one-piece CSG directly from OpenSCAD.  The
# monolithic core overlaps each face internally for robust Boolean input, but
# CGAL resolves those overlaps before the STL is written.  The delivered STL
# therefore contains one connected manifold surface, not three overlapping
# shells and not a triangle-soup concatenation.
if ! openscad \
  --export-format binstl \
  -o "$stl" \
  -D 'preset="hecate946"' \
  -D 'print_profile="library_fdm"' \
  -D 'part="behn_tray_one_piece_library_oriented"' \
  "$project_dir/src/export.scad" 2>"$log"; then
  cat "$log" >&2
  exit 1
fi
cat "$log"

python3 "$project_dir/scripts/validate_stl.py" "$stl" | tee "$out/STL_VALIDATION.txt"

cat > "$out/PRINT_ME.txt" <<'TXT'
HECATE946 / Behn-style 5-reed tray — ONE-PIECE library prototype

PRINT THIS FILE:
  behn_tray_ONE_PIECE.stl

MODEL STATUS:
- Complete double-sided tray: no gluing or assembly.
- Final STL is already Boolean-unioned by OpenSCAD/CGAL.
- One connected, watertight manifold shell.
- No overlapping-volume repair or mesh-repair option is required.
- STL has already been placed in its intended 45-degree long-edge orientation.
- Please keep the imported orientation; do not Lay Flat / Auto Orient it.

NORMAL PLA STARTING SETTINGS (0.4 mm nozzle):
- 0.24 mm layer height
- 3 walls/perimeters
- 4 top/bottom layers
- 15% infill
- supports OFF
- 8-12 mm brim for bed adhesion

If the estimate is already comfortably under the library's time limit, 0.20 mm
layers are fine. Do not change the model dimensions.

NOMINAL FINISHED FUNCTIONAL GEOMETRY:
- tray envelope before print rotation: 88.70 x 87.50 x 15.90 mm
- Boveda Size 8 opening: 71.85 x 5.10 mm
- hardware pockets: 4.20 mm diameter x 2.15 mm deep for nominal 4 x 2 mm discs
- silicone retention grooves: nominal 2.0 mm round silicone/O-ring material

STL_VALIDATION.txt beside this file is generated automatically from the actual
exported STL and confirms manifold edges, consistent winding, one connected
shell, positive enclosed volume, and print-bed placement.
TXT

echo
echo "READY FOR FLASH DRIVE:"
echo "  $stl"
echo "  $out/PRINT_ME.txt"
echo "  $out/STL_VALIDATION.txt"
