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
- separate moving latch plate with a large **48 x 6.65 mm** exterior push button
- one closing tongue with a `---\` outward face and a flat-underside catch
- no guide rails and no stop tabs; the inner front wall is the locked stop
- shallow slide pan recessed into the base floor, outer bottom shell intact
- no modeled spring; the future leaf spring remains a separate metal part
- recessed lid latch groove with no protruding lid striker
- continuous **2 x 175 mm silicone O-ring** prototype seal
- shallow `ASASI` mark at the lid's bottom right, controlled from `src/config.scad`
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
separate parameters in `src/config.scad`. The mount centers sit at **-42 and
+42 mm**, so the real leaf spring spans about 84 mm between the outer feet.
That span is deliberate: it clears the much wider latch plate. Expect to need
**0.5 mm or thicker** spring steel, because a thin 0.3 mm leaf over this span
delivers well under 1 N at full travel and feels dead.

### Moving latch piece

The latch is a separate component rather than part of the printable base. It is
a single flat plate, **56.0 x 4.0 mm** in plan, sliding in a **1.00 mm** deep pan
recessed into the interior base floor. The pan leaves **2.80 mm** of floor skin
and never breaks the exterior bottom shell. The pan's side walls guide the plate
in X; its rear wall sits 0.30 mm behind the fully pressed position and acts only
as an overtravel backstop.

There are no guide rails and no stop tabs anywhere in the design. At rest the
leaf spring pushes the plate outward until its full-width front face lands flat
on the inner front wall, so the locked stop is 56 mm of wall instead of two
small tabs.

Dropping the plate into the pan is what lets the button grow. The interior floor
sits above the exterior mid-plane, so a vertically centered button on the base
face is height-limited by the floor; the pan removes that limit. The integral
button is now **48.0 x 6.65 mm** with a **2.60 mm** corner radius, covering about
**13.7%** of the front face. Its center is derived from `x = 0` and
`z = v2_base_h / 2`, so it stays exactly centered. Its **2.60 mm** travel leaves
it exactly flush with the case wall when fully pressed.

#### Closing tongue and catch

One solid rises above the seam. Read its outward face top-down and it is
literally `---\`: a flat crown, then a single straight ramp falling outward to a
protruding catch. The descending lid wall rides that ramp and drives the whole
latch inward; when the lid pocket lines up, the spring snaps the catch in. Every
convex edge carries one **0.55 mm** radius and the single concave corner carries
a **0.35 mm** fillet.

The catch underside is **horizontal**. This is the important change from the old
hook. The seal load presses straight up into a flat **1.0 mm** deep bearing land
and cannot back-drive the latch. Previously the only thing holding the lid was a
sloped hook top at roughly 35 degrees, which meant the O-ring's own force was
continuously trying to eject the latch and the leaf spring was fighting the seal
the entire time the case was closed. Nothing carries the lock now except that
flat land.

Sequence: press the lid down to the seam, the catch slips in with **0.20 mm** of
room above and below, release, and the seal lifts the lid **0.20 mm** until the
pocket floor lands on the land. Locked O-ring squeeze is **0.35 mm**, about
17.5% of the 2 mm cord. Pressing the button retracts the catch **1.55 mm** past
the wall face, with 1.05 mm of travel to spare.

The tongue is set back **0.50 mm** from the plate's front face. Without that
setback the fillet under the catch, not the flat land, would be the first thing
the lid pocket touches, and the seat height would be wrong. `make check` catches
that case directly.

#### Lid pocket

The lid owns only a plain rounded pocket, **22.6 mm** wide and **1.80 mm** deep,
leaving **1.60 mm** of solid outer wall skin. Its floor sits **2.80 mm** above the
seam. The previous version placed it 1.60 mm above the seam, which left only
**0.15 mm** of lid material between the O-ring gland roof and the pocket floor.
That web is unprintable; it is now **1.35 mm** and is asserted.

The pocket roof is derived, not hand-set: it clears the point where the closing
ramp crosses the lid wall face, plus 0.25 mm. Change the tongue height or the
catch extension and the pocket follows.

All functional values are grouped under `MOVING FRONT LATCH PIECE` and
`CLOSING TONGUE AND CATCH` in `src/config.scad`.

#### Known limitation

The button opening is a straight 48 x 6.65 mm hole through the front wall into
the sealed interior. The O-ring seals the lid seam properly and then the case
breathes through the latch. This redesign does not fix that and it is probably
not fixable with an external push button; it needs either a gasketed button boot
or a latch that acts through the seam instead of through the wall. Decide that
before treating the Boveda humidity behaviour as real.

#### Views

Use `bottom_case` for the installed assembly, `bottom_case_shell` for the base
and its openings alone, `bottom_case_latch_fit` for a transparent fit view, and
`bottom_case_latch_pressed` for maximum inward travel.
`latch_groove_lock_detail` shows the catch seated on its land at the resting lid
height, `latch_groove_closing_entry` shows the moment of entry with the lid
pressed to the seam, `latch_button_release_detail` shows the catch fully
retracted, and `top_lid_latch_groove` isolates the pocketed center-front lid
section. Use `latch_piece` for the standalone moving component.

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
