# Parametric Airtight Reed Case

A modular OpenSCAD starting point for a premium, humidity-controlled Bb/Eb
clarinet reed case. The default preset uses the publicly listed exterior body
envelope of a Behn Clarinet Premium 20 case: **1.50 x 4.00 x 4.00 in**
(38.1 x 101.6 x 101.6 mm).

This is an original parametric implementation, not a dimensional copy of
Behn's unpublished internal geometry. Behn publicly identifies PLA, an
airtight rubber-gasket closure, perforated/railed trays, magnetic tray
retention in Premium models, and 72% Boveda packs. Those verified traits are
represented here; unpublished wall, rail, hinge, gasket-channel, and magnet
dimensions are clearly labeled engineering starting values.

## Quick start

1. Install OpenSCAD and the OpenSCAD VS Code extension.
2. Open this folder in VS Code.
3. Open `src/main.scad` and press **F5** to preview the assembly.
4. Change `preview_part` or `preset` near the top of `src/main.scad`.
5. Run `make stl` to export every printable part.

The included GitHub Actions workflow installs OpenSCAD, compiles the assembly,
and exports all printable parts on every push or pull request.

Useful commands:

```bash
make preview                 # fast CSG validation, no STL output
make stl                     # export Behn-envelope preset
make stl-size60              # export the Size 60 development preset
make check                   # dependency-free static checks
make clean
```

You can also export one part directly:

```bash
openscad -o build/base.stl \
  -D 'preset="behn_premium20"' \
  -D 'part="base"' src/export.scad
```

## Printable parts

- 1 x base shell
- 1 x lid shell
- 4 x ventilated reed plate (5 reeds each in the default preset)
- 4 x TPU retainer strip (optional; silicone bands also work)
- 1 x hinge pin, or use 1.75 mm filament / metal rod
- 1 x removable front latch clip (optional; closure magnets are supported)
- calibration coupons for fit, gasket compression, and magnets

The assembly preview uses all four reed plates. For printing, export one plate
and one retainer strip, then set quantity in the slicer.

## Where to edit

All normal design changes live in `src/config.scad`. Select a preset with the
`preset` variable:

- `behn_premium20`: 101.6 x 101.6 x 38.1 mm public Behn exterior body envelope,
  Size 8 humidity packs, 20 reeds.
- `size60_studio`: 151 x 124 x 48 mm development envelope for the Size 60 pack
  (133.35 x 88.9 mm), 28 reeds.

Start with `printer_clearance`, `gasket_compression`, `wall`, and
`tray_side_gap`. The geometry modules should usually not need editing.

## Important engineering note

An FDM print is not automatically airtight. Use at least five perimeters,
calibrate extrusion, test the gasket coupon, seal porous surfaces if needed,
and perform the leak test in `docs/PRINTING_AND_ASSEMBLY.md` before trusting
valuable reeds. Never wash or leave a PLA case in a hot car.

See `docs/` for dimensions, sources, bill of materials, printing, assembly,
and the boundary between verified product facts and original engineering
assumptions.
