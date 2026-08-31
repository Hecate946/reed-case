# Dual side-latch hardware

The side buttons use the same latch motion as the previous front button: the
lid cams each latch inward, the spring pushes the catch outward into the lid
groove, and pressing the button retracts the catch. There are two mirrored,
independent side mechanisms.

## Leaf spring

Target material: **301 full-hard stainless spring/shim stock, 0.006 in
(0.1524 mm)**.

Flat blank from `side_leaf_spring_strip.dxf`:
- 40 mm x 7 mm nominal blank
- two 2.3 mm screw holes on the 36 mm screw span
- make two identical pieces

At assembly, put a shallow outward bow in the strip so the center rises about
2.6-2.7 mm from the screw/cover plane. The two cover screws clamp the ends.
The button pushes the latch inward and nearly flattens this bow; the strip
returns the latch outward when released.

The design target is intentionally tunable. Start at 0.006 in. If the buttons
feel too light after the first physical prototype, try 0.007 or 0.008 in.
Do not jump to thick ordinary sheet metal; spring force rises roughly with the
cube of thickness.

For reference, using E ~= 193 GPa, a 36 mm span, 7 mm strip height, 0.1524 mm
thickness, and 2.6 mm center motion gives a simple beam estimate of roughly
1.1-4.3 N depending on how rigidly the ends behave. The fixed-end estimate is
about 708 MPa peak bending stress, below the ~965 MPa minimum 0.2% yield value
commonly specified for full-hard 301. This is only a prototype sizing model;
final feel and fatigue life should be validated physically.

## Metal mechanism cover

Use `side_latch_cover_plate.dxf`. Make **two identical pieces** from:
- 0.030 in / 0.76 mm 304 stainless steel
- deburred edges recommended

The plate screws into the two printed spring-support blocks and completely
shields the spring from the reed cartridge/user. The same two screws also
clamp the spring ends behind the plate.

Recommended prototype screws:
- 2x M2 x 5 mm thread-forming screws per side
- printed supports have 1.6 mm pilot holes
- cover/spring blanks have 2.3 mm clearance holes

For a more production-like version later, replace the thread-forming screw
joint with a suitable miniature threaded insert or molded metal boss after the
case material/process is finalized.

## Export commands

```bash
make export-side-latch-hardware
```

This produces STL reference models plus both DXF cutting templates under:

`build/reed-case-prototype/side-latch-hardware/`
