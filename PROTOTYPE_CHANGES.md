# 2026-08-29 — one-piece library tray export

- `make stl-tray` produces exactly one finished STL: `behn_tray_ONE_PIECE.stl`.
- The face/core regions overlap by 0.15 mm only as internal CAD input to make the Boolean robust. OpenSCAD/CGAL resolves that overlap before writing the STL.
- The delivered STL is one connected watertight manifold surface; it does **not** rely on slicer-side "union overlapping volumes" behavior.
- Each detailed face and the monolithic core are pre-rendered as CGAL polyhedra before the final three-body Boolean union, which makes the operation practical in OpenSCAD 2021.
- `scripts/validate_stl.py` automatically rejects the export unless every welded edge is manifold, winding is consistent, there is exactly one connected shell, enclosed volume is positive, and the print orientation sits at Z=0.
- The output STL is pre-oriented 45° on its long edge to avoid the approximately 72 mm unsupported Boveda-tunnel ceiling a flat monolithic print would create.
- `make stl-tray-parts` remains available only as a legacy three-piece fallback.

# Prototype tray changes

This revision is aimed at printing **one tray first**.

- Default OpenSCAD preview/export target is one assembled tray, not the case.
- `make stl` exports only one tray's physical pieces: face A, face B, core.
- Removed the redundant outer reed divider on both sides. The left/right structural edge wall now directly bounds the outer reed passage.
- Tray body width is now 88.7 mm instead of 91.9 mm on `behn_premium20`, saving 1.6 mm per side while preserving 14.30 mm clear width in every reed slot.
- Boveda Size 8 opening remains 71.85 mm wide x 5.10 mm high.
- Both silicone O-ring grooves remain at the same height.
- 2.0 mm round silicone is the intended retention material; 60 mm ID is the first O-ring size to try.
- Magnet/steel decision is deferred; both faces use identical hardware pockets.
- Hardware pocket is 4.20 mm straight diameter x 2.15 mm depth for nominal 4 x 2 mm discs.
- Added 0.15 mm pocket lead-in chamfer.
- Added small top-edge softening to the reed platform and raised guide/frame walls.
- Kept the rounded heel-side guide runout and softened ventilation rims.
- Added a 2.0 mm heel bridge to the tray core so the core is one connected U-shaped print instead of two loose side rails.
- Left the outer shell/gasket out of this prototype pass; it still needs a dedicated closure/seal redesign before final printing.
- Corrected stale 6 x 2 mm magnet documentation.
- Polarity instructions were intentionally removed from the prototype workflow; decide that after the physical fit test.

- Reversed the heel-end quarter-round curvature so each divider/side wall rises smoothly out of the reed plane instead of forming the previous rounded-nose profile.
## 2026-08-29 — Symmetric Boveda-core mouth

- Rebuilt the open ends of the Behn tray core as true semicircular/pill caps.
- The inner and outer sides of each core rail now use the same radius, so each
  end reads as `()` instead of a convex outside corner with a concave bite.
- Boveda channel width, core height, heel bridge, and tray fit are unchanged.


## 2026-08-29 — HECATE946 nested-tray views + structural partitions

- Added two full-depth, low structural divider ribs to the HECATE946 base:
  - one between the humidity-reader bay and tray 1
  - one between tray 1 and tray 2
- Each divider is 1.60 mm thick and centered in the existing 2.40 mm gap, so
  the original tray-well clearances are unchanged.
- Divider height is 5.50 mm above the interior floor and the ribs fuse into
  the front/rear shell walls for extra stiffness.
- Added three fit-inspection preview modes using the actual detailed Behn tray:
  `hecate946_nested`, `hecate946_nested_exploded`, and `hecate946_one_tray_fit`.
- `src/main.scad` now defaults to `hecate946_nested` so the tray-to-case fit is
  immediately visible when opening the project.

## HECATE946 tray orientation + structural partitions (2026-08-29)

- Rotated both nested Behn trays 180 degrees in HECATE946 so their open reed-insertion/heel ends face the front click-latch/opening side rather than the hinge.
- Standalone Behn tray geometry and STL exports are unchanged.
- Raised both internal partitions from the interior floor all the way to the base seam.
- Increased partition thickness from 1.60 mm to 2.20 mm. The walls remain inside the existing 2.40 mm inter-bay gaps, preserving the tray locating wells and leaving about 0.50 mm physical tray-to-divider clearance.

## HECATE946 snap hinge + standard seal

- Replaced the long interleaved HECATE946 hinge with four short base bearings
  and three minimal C-clips on the lid.
- The clips snap over a 2.0 mm stainless-steel/music-wire axle and then rotate
  on that metal surface.
- Added a three-mouth hinge coupon (1.45 / 1.55 / 1.65 mm) for material/printer
  calibration before a full lid print.
- Re-targeted the perimeter groove to a standard **2x185 mm silicone O-ring**.
  The design computes about 1.8% installed stretch and 25% nominal compression.
- Added `hecate946_seal_view` to show the O-ring seated in the lid groove.

## 2026-08-29 — Library print preflight

- Added `make stl-tray`, an explicit export target for **only one complete tray**.
- `make stl-tray` now writes the final one-piece STL, `PRINT_ME.txt`, and an
  automatic `STL_VALIDATION.txt` report to `build/library-tray-one-piece/`.
- Added `make check-tray` to instantiate/preflight all three tray parts without
  rendering the rest of the enclosure.
- Moved the humidity-pack stop ribs out of the two reed faces and into the
  center core. Both faces now have flat Z=0 backs, and the core is also flat,
  so all three pieces are support-free in their intended print orientation.
- Added a 0.10 mm positive overlap between the raised tray walls and the
  perforated face sheet so the STL cannot rely on a zero-thickness coplanar
  seam.
- Added a `library_fdm` export profile. Functional dimensions are unchanged;
  it skips only the 0.18 mm cosmetic vent-hole rim relief and uses printer-
  appropriate curve resolution for much faster OpenSCAD 2021 STL export.
- Verified the library STLs are each one connected, watertight mesh with
  consistent winding.
- Verified exported bounding boxes: faces 88.70 x 87.50 x 5.40 mm each; core
  88.70 x 87.50 x 5.10 mm; assembled nominal tray thickness 15.90 mm.

## Robust one-piece library STL

- `make stl-tray` now exports the real `behn_tray_one_piece_library_oriented` CSG directly through OpenSCAD/CGAL instead of concatenating three STL shells.
- The 0.15 mm face/core overlap exists only inside the CAD Boolean; it is resolved before STL output.
- `scripts/validate_stl.py` checks the actual delivered STL for manifold edge incidence, consistent winding, a single connected shell, positive volume, and Z=0 print-bed placement. The Make target fails on any validation error.
- Removed the obsolete `merge_onepiece_stl.py` shell-merging path.
- Library-FDM tessellation is intentionally 20-sided at the global circular resolution (with local overrides where appropriate), which is below 0.4 mm nozzle resolution while making the final Boolean practical. Nominal dimensions are unchanged.
