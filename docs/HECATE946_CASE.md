# HECATE946 side-by-side case

`hecate946` is the new enclosure preset. It keeps the current five-lane
Behn-style tray geometry unchanged and places **two complete trays side by
side** in the base.

## Layout

- Outer body: **214.0 x 97.0 x 25.0 mm** (external snap hinge brings overall depth to about **103.7 mm**).
- Tray footprint used by each well: **88.70 x 87.50 mm**.
- Tray-well clearance: **0.40 mm per side**.
- Tray-well recess: **0.60 mm** deep.
- Two tray wells are separated by **2.40 mm**. A **2.20 mm-thick structural
  wall** is centered in that strip. It stays 0.10 mm away from either locating-
  well cut; because the tray itself has 0.40 mm well clearance, the physical
  tray remains about 0.50 mm from the divider.
- Far-left hygrometer recess is currently a **22 x 50 mm placeholder** and is
  intentionally provisional until the exact reader is selected.
- A matching **2.20 mm structural wall** separates the hygrometer zone from the
  first tray bay. Both partitions extend from the interior floor to the **full
  base seam height** and join the front/rear cup walls, adding stiffness to the
  long enclosure.

The 214 mm width intentionally keeps the shell within a nominal 220 x 220 mm
printer bed. A slicer skirt/brim can require additional bed margin.

## Fit-inspection views

`src/main.scad` includes dedicated views using the **actual detailed Behn tray
geometry** rather than bounding-box placeholders:

- `hecate946_nested` — both trays fully seated in the real wells
- `hecate946_nested_exploded` — trays lifted 18 mm to expose wells, dividers,
  and floor hardware pockets
- `hecate946_one_tray_fit` — one tray seated while the other bay remains open

Both detailed trays are rotated in HECATE946 so their open reed-insertion/heel
ends face the front click-latch/opening side, opposite the hinge. The generic
grey hygrometer block in these views is preview-only and is not part of the
exported shell STL.

## Tray-to-case hardware alignment

Each tray well has four upward-facing pockets positioned at the exact same
local X/Y coordinates as the four pockets on the current tray:

- nominal hardware: **4 x 2 mm** disc
- printed pocket: **4.20 mm diameter x 2.15 mm deep**
- 0.15 mm lead-in chamfer

There are eight case-floor pockets total. They may later receive magnets,
steel discs, or remain empty. No polarity scheme is baked into the geometry.
Because the tray pocket pattern is symmetric, either tray face can be placed
downward and the hardware locations still register.

## Seal

The lid now targets a **standard closed metric silicone O-ring: 185 mm ID x
2 mm cross-section (2x185)** rather than cut-and-glued gasket cord. The groove
is 2.20 mm wide and 1.50 mm deep. The rounded-rectangle groove centreline is
about **598.2 mm** long, while the free O-ring centreline is about **587.5 mm**,
so the ring installs at approximately **1.8% stretch**. That small preload keeps
it seated around the corners without pulling it excessively tight.

With a 2.0 mm round section sitting 1.50 mm deep, approximately 0.50 mm remains
proud, giving about **25% axial compression** against the flat base rim at full
closure. The source contains an assertion that keeps installed O-ring stretch
between 1% and 5% if the shell dimensions are edited later.

`hecate946_seal_view` shows the gasket path in red. A physical humidity/leak
test is still required before treating any 3D-printed enclosure as airtight;
print surface texture, latch preload, and material porosity all affect the real
seal.

## Closure

Two front flex latches are integrated into the lid. Each arm rides outside a
rounded catch on the base and an inward hook clicks beneath the catch at full
closure. Pull the small lower finger tab outward to release.

For repeated use, PETG or nylon is preferable to brittle PLA for the latch
arms. PLA is fine for checking fit and the closing feel on a prototype.

## Hinge

HECATE946 now uses a **minimal snap-on metal-axle hinge** instead of a nearly
full-width printed interleaved barrel.

- axle: **2.0 mm stainless-steel rod / music wire**
- suggested rod blank: **200 mm**, cut to about **190 mm**
- base: four short **10 mm** support barrels with a **2.25 mm** running bore
- lid: three **14 mm** C-clips with a **2.35 mm** running bore
- production clip mouth: **1.55 mm**, narrower than the 2 mm axle so it snaps
  over the rod and retains it
- clip outside diameter: **6.4 mm**

The rod slides through the base supports first. The lid can then be aligned
over the exposed axle and pressed on; the three printed C-clips flex over the
rod and rotate on the metal surface during normal use. This keeps the hinge
visually small while moving the wear surface to replaceable metal.

For repeated clip-on removal, PETG or nylon is strongly preferred to PLA. The
lid does not need to be removed during normal use, so once assembled the clips
mostly act as bearings rather than flexing every time the case is opened.

`hecate946_hinge_coupon` contains three production-style clips with 1.45, 1.55,
and 1.65 mm mouths. Test a real 2.0 mm rod in that coupon before printing the
full lid on a new printer/material.

## Exports

```bash
make stl-hecate946
```

Exports:

- `hecate946_base.stl`
- `hecate946_lid.stl`
- `hecate946_hinge_coupon.stl`

To export those plus one complete tray set and the existing tolerance coupons:

```bash
make stl-hecate946-all
```

The two tray bays use identical trays, so print **two copies** of the same tray
parts rather than maintaining duplicate tray STL files.

## Tray orientation and full-height partitions

Both Behn trays are installed with their open reed-insertion (heel) ends facing the front click-latch/opening side of HECATE946. The enclosure applies a 180-degree placement rotation only; the standalone tray model is unchanged.

The humidity-reader/tray and tray/tray partitions are 2.20 mm thick and extend from the interior floor to the base seam. They tie into the front and rear shell walls for stiffness while retaining the original tray-well clearances.
