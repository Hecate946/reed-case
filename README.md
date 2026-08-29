# Parametric Airtight Reed Case

OpenSCAD source for a humidity-controlled Bb/Eb clarinet reed case. The
current default is intentionally focused on **one double-sided prototype
tray**, not the outer shell, so the reed fit, Boveda opening, silicone O-ring
grooves, and 4 x 2 mm hardware pockets can be tested before paying for the
whole case.

The default `behn_premium20` envelope is based on the publicly listed Behn
Premium 20 exterior size: **101.6 x 101.6 x 38.1 mm**. Millimeter dimensions
that Behn does not publish are engineering starting values and should be
validated physically.

## Prototype first

Open `src/main.scad`: it previews one complete tray by default.

```bash
make check
make preview
make stl
```

`make stl` now exports **only the three pieces required for one complete
tray**:

- `behn_tray_face_a.stl`
- `behn_tray_face_b.stl`
- `behn_tray_core.stl`

They are separate on purpose. A monolithic FDM print would create a large,
hard-to-support internal bridge inside the Boveda channel. Print the two faces
flat with their reed features upward, print the core on either broad face, then
dry-fit/bond them after the fit checks.

To export the whole case later:

```bash
make stl-all
```

The CLI default is also the assembled tray preview:

```bash
openscad -o build/tray.csg src/export.scad
```

## Current prototype dimensions

For `behn_premium20`:

- Complete tray body: about **88.7 x 87.5 x 15.9 mm**
- Boveda Size 8 nominal face: **69.85 x 63.50 mm**
- Boveda channel opening target: **71.85 mm wide x 5.10 mm high**
- Reed passages: **14.30 mm clear**
- The two outer passages use the structural side borders as their outside walls; there are no redundant outer dividers
- Two silicone O-ring/round-cord grooves per face, both at the same height
- Groove is sized around **2.0 mm round silicone**
- Hardware pocket straight bore: **4.20 mm diameter x 2.15 mm deep**
- Pocket mouth includes a **0.15 mm lead-in chamfer**
- Hardware choice/polarity is intentionally deferred; both faces use the same
  pocket geometry and can later take a 4 x 2 mm magnet or matching steel disc

A 60 mm ID x 2 mm cross-section silicone O-ring is the first tension to try;
58/60/63 mm IDs are useful prototype comparisons if available.

## Important prototype checks

Before changing the CAD further, use this first tray to verify:

1. A real reed slides in tip-first without contacting a sharp edge.
2. The two silicone rings grip firmly without distorting the reed.
3. A fresh/hydrated Boveda Size 8 slides through the channel without binding.
4. Your actual 4 x 2 mm magnets/discs fit the pockets by hand.
5. The tray feels rigid enough when handled by the side borders.

The top edges of the reed-facing platform and raised walls now have small
printable chamfers, while the ventilation holes retain their softened rims and
the heel-side guide runout remains rounded.

## Other commands

```bash
make preview-all        # compile the full case assembly
make stl-all            # export all Behn-envelope parts
make stl-size60         # one Size-60 tray prototype
make stl-size60-all     # all Size-60 parts
make clean
```

See `docs/` for hardware, dimensions, printing, assembly, and reference notes.
