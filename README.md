# Reed case CAD

OpenSCAD source for the **V2 premium-style clarinet reed case prototype**.
The project is intentionally small: one tray design, one enclosure design, one
configuration file, and one source-zip script.

## V2 concept

- compact **190 x 97 x 24.5 mm** two-tray enclosure
- no hygrometer bay yet; the sensor will be integrated only after the case is right
- two removable double-sided 10-reed trays
- four D4x2 retention points per tray
- replaceable **2 mm metal hinge pin** with alternating printed knuckles
- dual printed click latches for testing closure feel
- continuous **2 x 170 mm silicone O-ring** prototype seal
- shallow `HECATE946` lid engraving, controlled from `src/config.scad`
- dark-teal shell / white-tray colors in OpenSCAD previews only

The plastic V2 is a design-validation prototype. The final aluminum case should
use production-specific hinge/latch hardware after the dimensions and feel are
frozen.

## Files that matter

```text
src/config.scad          dimensions + hardware + easy customization
src/main.scad            interactive OpenSCAD preview
src/assembly.scad        views and part routing
src/parts/tray.scad      reed tray geometry
src/parts/case.scad      V2 enclosure geometry
src/parts/calibration.scad
src/lib/                 small reusable geometry/hardware helpers
Makefile                 all checks / exports
scripts/make-source-zip.sh
```

## Normal workflow

Open `src/main.scad` in OpenSCAD. The default is the fine-mesh exploded V2 view.
The file intentionally keeps every useful `view = ...` option commented directly
below the active line so switching views stays one-line simple:

```text
v2_open
v2_closed
v2_exploded
v2_closed_front
v2_base_fit
v2_seal
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
build/v2-prototype/case_base.stl
build/v2-prototype/case_lid.stl
build/v2-prototype/tray-parts/tray_face_a.stl
build/v2-prototype/tray-parts/tray_core.stl
build/v2-prototype/tray-parts/tray_face_b.stl
build/v2-prototype/fit_coupon.stl
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

## First physical V2 test

Use inexpensive PLA/PETG. Before committing to a long print, print
`fit_coupon.stl` and verify the actual 2 mm hinge rod and D4x2 hardware fit.
For the complete prototype, install the real hinge pin, magnets/steel targets,
silicone cord used for reed retention, and the intended O-ring. Evaluate the
case size, reed access, tray removal, magnet feel, latch force, hinge feel, and
seal compression before changing anything for CNC aluminum.
