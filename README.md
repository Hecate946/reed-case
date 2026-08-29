# Reed case CAD

OpenSCAD source for a humidity-controlled clarinet reed case.

The default preview is now the **HECATE946** enclosure: two of the current
five-lane double-sided reed trays nested side-by-side, plus a provisional
humidity-reader bay at the far left. The original Premium-20 reference shell
and Size-60 preset remain available.

## HECATE946 case

Open `src/main.scad`. It now defaults to the **nested-trays fit view**, so you
can see both complete Behn trays seated inside the HECATE946 base. Additional
selectable views at the top of `main.scad` include:

- `hecate946_nested` — both real trays seated in the base
- `hecate946_nested_exploded` — both trays lifted above their wells
- `hecate946_one_tray_fit` — one bay exposed and one tray seated
- `hecate946_assembly` — complete closed enclosure
- `hecate946_seal_view` — lid with the standard O-ring path highlighted
- `hecate946_hinge_coupon` — three snap-mouth fits for a real 2 mm rod

Or run:

```bash
make preview-fit
```

Current HECATE946 shell:

- 214.0 x 97.0 x 25.0 mm body
- two exact 88.70 x 87.50 mm tray footprints side-by-side
- 0.40 mm clearance around each tray in a 0.60 mm-deep locating well
- provisional 22 x 50 mm humidity-reader recess at far left
- two 2.20 mm full-height structural divider walls: one between the reader bay
  and first tray, and one between the two tray bays; both run from the interior
  floor to the base seam
- both Behn trays oriented with their open reed-insertion ends facing the front
  click-latch/opening side
- eight 4.20 x 2.15 mm case-floor hardware pockets aligned exactly with the
  four pockets on each tray
- continuous groove for a standard **185 mm ID x 2 mm CS silicone O-ring**,
  installed at about 1.8% stretch and ~25% nominal compression
- two integrated front click latches
- minimal snap-on hinge: four short base bearings retain a **2.0 mm stainless
  rod**, while three C-clips on the lid snap onto the exposed metal axle

See `docs/HECATE946_CASE.md` for the detailed dimensions and rationale.

Export the shell and the small hinge-fit coupon with:

```bash
make stl-hecate946
```

## Current five-lane tray

The tray design itself is unchanged by the new enclosure. One complete tray
uses:

- `behn_tray_face_a`
- `behn_tray_face_b`
- `behn_tray_core`

Key dimensions:

- complete tray: about 88.70 x 87.50 x 15.90 mm
- five 14.30 mm-clear reed passages per face
- Boveda Size 8 opening: 71.85 mm wide x 5.10 mm high
- two equal-height grooves for 2.0 mm round silicone cord/O-rings
- four identical 4.20 x 2.15 mm D4x2 hardware pockets on each face
- rounded open-end guide runouts and rounded Boveda-core mouth caps

For the **library PLA prototype**, export the complete permanently fused tray
as a single STL with:

```bash
make stl-tray
```

That writes `build/library-tray-one-piece/behn_tray_ONE_PIECE.stl`, a print
note, and `STL_VALIDATION.txt`. OpenSCAD performs the final CGAL Boolean union
before export, and the validation script refuses the file unless it is one
connected watertight manifold with consistent winding. The STL is pre-oriented
45 degrees on its long edge to avoid the
large unsupported bridge that a flat one-piece print would create over the
Boveda tunnel. Do not auto-orient or lay it flat in the slicer. The library
profile preserves every functional dimension while omitting only sub-nozzle
cosmetic hole-rim relief. The former three-part export remains available as
`make stl-tray-parts`.

The two HECATE946 bays use identical trays, so print **two copies** of the same
tray set when you are ready to populate both sides of the case.

## Useful commands

```bash
make check
make check-tray           # fast compile/preflight of the one-piece tray
make preview              # HECATE946 closed assembly CSG
make preview-fit          # base + both detailed trays seated
make preview-fit-exploded # lifted trays exposing wells/dividers
make preview-seal         # lid + highlighted 2x185 O-ring path
make stl-tray             # library-ready ONE-PIECE tray STL
make stl-tray-parts       # legacy three-piece tray export
make stl                  # production-mesh three-part tray
make stl-hecate946        # HECATE946 base, lid, hinge coupon
make stl-hecate946-all    # case + one tray set + calibration coupons
make stl-all              # original Premium-20 parts
make stl-size60           # one Size-60 tray set
make stl-size60-all       # all Size-60 parts
make clean
```

Before a final-material print, physically verify reed fit, silicone tension,
Boveda fit, D4x2 hardware fit, hinge-pin clearance, latch feel, and gasket
sealing on the actual printer/material combination.
