# Reed case CAD

OpenSCAD source for the **premium-style clarinet reed case prototype**.
The project is intentionally small: one tray design, one enclosure design, one
configuration file, and one source-zip script.

## Prototype concept

- compact **190 x 107 x 24.5 mm** two-tray enclosure
- no hygrometer bay yet; the sensor will be integrated only after the case is right
- two removable double-sided 10-reed trays
- four D4x2 retention points per tray
- replaceable **2 mm metal hinge pin** with alternating printed knuckles
- two full-height, sharp-cornered mirrored stepped spring-support blocks
- separate full-height moving draw latch with exterior push button, protruding
  rounded hook, pull-down ramp, and positive locking land
- intact outer base floor with a fitted front-wall button opening
- no modeled spring; the future leaf spring remains a separate metal part
- recessed lid latch groove with no protruding lid striker
- continuous **2 x 175 mm silicone O-ring** prototype seal
- shallow `HECATE946` lid engraving, controlled from `src/config.scad`
- dark-teal shell / white-tray colors in OpenSCAD previews only

The trays sit slightly toward the hinge, leaving a dedicated front service strip
for the two spring supports shown in the supplied sketch.

### Leaf-spring mounting architecture

Only the case-side stepped solids exist in CAD. They intentionally have no
screw holes, spring channels, rounded corners, or enclosed cutouts. From the
top, each has a full-width back section and a half-width outward front leg;
the right piece is the exact horizontal mirror of the left. Open
`bottom_case` to debug the bottom piece alone; the real fused mount solids are
orange. Use `leaf_spring_mount_pair` to inspect both blocks without the
case. `left_leaf_spring_mount` and `right_leaf_spring_mount` expose each module
separately for dimension changes and standalone STL checks.
Each piece fits within a **13.0 x 8.5 x 8.45 mm** envelope and extends from the
base floor to the case seam. The front step depth and outer-foot width are
separate parameters in `src/config.scad`.

### Moving latch piece

The latch is a separate component rather than part of the printable base. The
spring-mount centers are spread to **-25 and +25 mm**, giving a 37 mm closest
gap. The latch body's longest side is now only **24 mm**, leaving **6.5 mm** of
space to each mount. The body sits entirely on top of the interior floor,
extends to the case seam, and never enters or protrudes through the exterior
bottom shell. Its
**20.0 x 4.0 mm** integral button uses a consistent **1.65 mm rounded-corner
radius**, passes through a matching rounded wall opening, and projects
3.2 mm outside. Its center is derived directly from `x = 0` and
`z = v2_base_h / 2`, so it is exactly horizontally and vertically centered on
the bottom case. The rear rectangle ends exactly at the base seam. A centered
**16.0 x 3.2 mm** upright tongue rises 6.4 mm above it; because its depth equals
the rear rectangle depth, it is never thicker than the rectangle beneath it.
The working hook is fused directly to this tongue and projects outward toward
the lid wall.

The rounded hook nose is pushed inward by the descending lid wall. Once its
matching groove reaches the hook, the spring returns the latch outward and
inserts the hook into the groove. The hook's top rises **0.60 mm** from its root
land to its nose; moving outward makes the fixed groove roof follow that surface
downward, pulling the lid onto the seal. This matches the current 2 mm O-ring's
**0.55 mm** protrusion above its groove and leaves 0.05 mm of nominal hard-stop
overtravel. A 0.60 mm flat root land gives the latch a settled locked position
instead of leaving it able to back-drive along the incline. Pressing the
exterior button through its **3.20 mm** travel completely retracts the hook and
leaves the button exactly flush with the case wall.

The lid now owns only a **15.7 mm-wide, 1.45 mm-deep** recessed groove. Its
profile is low at the inner locking edge and rises inside the pocket to clear
the hook ramp and rounded nose. It leaves **1.35 mm** of solid outer wall and
starts 0.15 mm above the O-ring gland, so the latch groove never opens into or
interrupts the continuous seal groove. The future real leaf spring sits between
the mount pair and rear rectangle; the spring itself remains absent from CAD.
All functional values are grouped under `MOVING FRONT LATCH PIECE` in
`src/config.scad`.

Two **2.4 mm-high** base-integrated guide rails hold the moving plate square
through its full stroke. Mirrored stop tabs define both the spring-biased locked
endpoint and the fully pressed endpoint with 0.05 mm nominal clearance. The
rear stops physically prevent the button from traveling past flush. The guides
stay low so they do not consume the upper region reserved for the future metal
leaf spring.

Use `bottom_case` for the installed assembly, `bottom_case_shell` for the base
and its openings alone, `bottom_case_latch_fit` for a transparent fit view, and
`bottom_case_latch_pressed` for maximum inward travel.
`latch_groove_lock_detail` shows the hook seated in the groove,
`latch_groove_closing_entry` shows the lid 0.60 mm above that position,
`latch_button_release_detail` shows the hook fully retracted, and
`top_lid_latch_groove` isolates the grooved center-front lid section.
Use `latch_piece` for the standalone moving component.

Use `bottom_case_boveda_size_60` to see one Boveda Size 60 centered in the
empty bottom case. Its **133.35 x 88.90 mm** footprint follows Boveda's published
3.5 x 5.25 inch product dimensions. The 6 mm preview thickness is adjustable
and is not treated as an official manufacturing dimension.

## Files that matter

```text
src/config.scad          dimensions + hardware + easy customization
src/main.scad            interactive OpenSCAD preview
src/assembly.scad        views and part routing
src/parts/tray.scad      reed tray geometry
src/parts/case.scad      enclosure geometry
src/parts/spring_mounts.scad
src/parts/calibration.scad
src/lib/                 small reusable geometry/hardware helpers
Makefile                 all checks / exports
scripts/make-source-zip.sh
```

## Normal workflow

Open `src/main.scad` in OpenSCAD. The file intentionally keeps every useful
`view = ...` option commented directly below the active fine-mesh view, so
switching views stays one-line simple:

```text
bottom_case
bottom_case_boveda_size_60
bottom_case_shell
bottom_case_latch_fit
bottom_case_latch_pressed
latch_piece
latch_groove_lock_detail
latch_groove_closing_entry
latch_button_release_detail
top_lid_latch_groove
leaf_spring_mount_pair
left_leaf_spring_mount
right_leaf_spring_mount
case_open
case_closed
case_exploded
case_closed_front
bottom_case_with_trays
lid_seal
tray
print_layout
```

All functional dimensions are in `src/config.scad`.


### Reed reference model

Preview reeds use the footprint and thickness envelope of a French/Boehm Bb
clarinet reed: **67.5 mm long, 13.15 mm maximum width, 11.0 mm heel width,
34.1 mm vamp, 3.05 mm nominal heel thickness, and 0.10 mm tip thickness**.
The intended reference is the Vandoren Traditional Bb strength 3.5 (CR1035).
Vandoren identifies that product/strength but does not publish its proprietary
full manufacturing profile, so the preview uses documented clarinet-reed
measurements for fit and clearance rather than claiming an exact factory cut.

### Export the prototype

```bash
make check
make export
```

The printable files are written to:

```text
build/reed-case-prototype/case_base.stl
build/reed-case-prototype/case_lid.stl
build/reed-case-prototype/latch/latch_piece.stl
build/reed-case-prototype/spring-mounts/left_leaf_spring_mount.stl
build/reed-case-prototype/spring-mounts/right_leaf_spring_mount.stl
build/reed-case-prototype/tray-parts/tray_face_a.stl
build/reed-case-prototype/tray-parts/tray_core.stl
build/reed-case-prototype/tray-parts/tray_face_b.stl
build/reed-case-prototype/fit_coupon.stl
```

The tray intentionally exports as **three support-free STLs**: face A, core,
and face B. Print each of those files twice, then assemble two double-sided
trays. This is the reliable cheap-prototype workflow; OpenSCAD becomes
unnecessarily slow when Boolean-unioning the hundreds of ventilation features
into a single monolithic STL. Do not glue a tray until the real Boveda pack has
been test-fitted.

### Quick visual render

```bash
make render
```

This writes the open, closed, front, exploded, tray-fit, and seal views to `build/renders/`.

### Share the latest source

```bash
make zip
```

This always replaces one file at the project root:

```text
reed-case-source.zip
```

Upload that ZIP when you want another design/code pass. There are no dated or
numbered source archives created by the project.

## First physical test

Use inexpensive PLA/PETG. Before committing to a long print, print
`fit_coupon.stl` and verify the actual 2 mm hinge rod and D4x2 hardware fit.
For the complete prototype, install the real hinge pin, magnets/steel targets,
silicone cord used for reed retention, and the intended O-ring. Test the chosen
spring-retention method before installing the real metal spring. Evaluate the case
size, reed access, tray removal, magnet feel, latch force, hinge feel, and seal
compression before changing anything for CNC aluminum.
