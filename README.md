# Reed case CAD

OpenSCAD source for the current H946 reed-case prototype.

## Current architecture

- **190 x 101 x 31.5 mm** symmetric enclosure
- **4.2 mm case walls**, 4.2 mm base floor, 3.4 mm lid roof
- one centered removable **10-reeds-per-face / 20-reed** cartridge
- integrated centered humidity bay for **2 x Boveda Size 8** packs
- removable slatted humidity cover resting on a continuous ledge; no cover magnets yet
- one centered **front push-button latch**
- replaceable 2 mm metal hinge pin
- perimeter 2 mm silicone O-ring seal

The reed cartridge and humidity bay are both centered at `x = 0, y = 0`. The
case margins are therefore symmetric left/right and front/back. The only
mechanical service area is the compact latch centered in the front wall.

## Front latch

The front latch preserves the same mechanical logic used in the previous side
version:

1. a flat moving plate is spring-biased outward;
2. the lid wall rides the rounded closing ramp and pushes the plate inward;
3. the spring snaps the flat-underside catch into a recessed groove in the lid;
4. pressing the exterior button retracts the catch;
5. at full press the button is exactly flush with the exterior wall.

The mechanism is now narrower:

- 24 mm moving plate
- 20 x 7.2 mm visible button
- 2.60 mm travel
- 31 mm spring screw span
- one 0.76 mm stainless interior cover plate

The normal assembly preview colors the button the same dark teal as the shell so
it reads as a built-in part of the centered front wall. Use
`front_latch_mechanism` for the exposed hardware/debug view.

### Leaf spring

Start with **0.006 in / 0.1524 mm 301 full-hard stainless**. The exact spring
force should be tuned after a physical prototype. The two support blocks and
cover geometry are generated from `src/config.scad`.

Hardware templates are in:

```text
hardware/front_latch_cover_plate.dxf
hardware/front_leaf_spring_strip.dxf
hardware/FRONT_LATCH_HARDWARE.md
```

Export them again with:

```bash
make export-front-latch-hardware
```

## Humidity bay

Two Boveda Size 8 packs sit centered in separate floor compartments a few
millimeters larger than the pack envelopes. A thin slatted lid rests on a ledge
around the full opening and sits flush with the surrounding support surface.
There are intentionally **no humidity-cover magnets yet**.

Useful views:

```scad
view = "humidity_bay_closed";
view = "humidity_bay_open";
```

`humidity_bay_open` removes the cover completely so both pack compartments are
visible.

## Reed cartridge

The current `tray` is the H946 open-air cartridge:

- 10 reeds per face
- 20 total
- five low breathing runners per reed lane
- runners support the first 65% of each reed
- final 35% toward the tip is fully open
- two push-down O-ring retention lines at 40% and 50%

The archived reference geometry remains available as `behn_tray`.

Useful views:

```scad
view = "tray";
view = "tray_test";
view = "behn_tray";
```

## Main views

Open `src/main.scad` and change the single `view = ...` line. Common views:

```text
case_open
case_closed
case_closed_front
case_exploded
bottom_case
bottom_case_with_trays
front_latch_mechanism
bottom_case_latch_fit
bottom_case_latch_pressed
humidity_bay_closed
humidity_bay_open
tray
tray_test
lid_seal
print_layout
```

## Export commands

```bash
make check                         # run geometry / latch interference checks
make export-case                   # case_base.stl + case_lid.stl
make export-latch                  # one front latch STL
make export-front-latch-hardware   # metal cover/spring reference + DXFs
make export-humidity-cover         # removable slatted humidity lid
make export-tray-full              # complete tray as one STL
make export-tray                   # tray halves
make export-fit                    # hardware fit coupon
make export                        # complete prototype set
make help                          # show commands
```

Use `PROFILE=fine` for final/high-detail exports, for example:

```bash
make export-tray-full PROFILE=fine
```

## Source layout

```text
src/config.scad             all functional dimensions
src/main.scad               interactive OpenSCAD entry point
src/assembly.scad           views / assembly routing
src/parts/tray.scad         reed cartridge geometry
src/parts/case.scad         base, lid, humidity bay
src/parts/latch.scad        moving latch + lid groove
src/parts/spring_mounts.scad spring supports + metal-cover geometry
hardware/                   generated metal templates / notes
Makefile                    checks and exports
```


Recent update: the front latch now uses **option #3** from the design discussion: a lowered hook in the base plus a **descending striker** on the lid, so nothing rises into the reed extraction path.
