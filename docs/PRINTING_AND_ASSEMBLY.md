# Printing and assembly

## 1. Current goal: one tray prototype

For the first physical test, do **not** print the outer shell yet.

Run:

```bash
make stl
```

This exports one `behn_tray_face_a`, one `behn_tray_face_b`, and one
`behn_tray_core`. Together they make a single double-sided 10-reed tray.

The pieces remain separate for support-friendly FDM printing. A one-piece
assembled version would place a large roof over the internal Boveda channel
and is not the cheap/prototype-friendly print path.

### Print orientation

- Face A: flat platform on the bed, reed rails/walls upward.
- Face B: flat platform on the bed, reed rails/walls upward.
- Core: either broad face on the bed.
- Prototype material: ordinary PLA is sufficient.
- Start around 0.16-0.20 mm layers, 4 walls, and ~20-25% infill.

Use no supports in the magnet pockets, O-ring grooves, or Boveda opening.

## 2. Fit checks before bonding

### Boveda

The default Size 8 channel is designed around:

- nominal pack face: 69.85 x 63.50 mm
- opening width target: 71.85 mm
- opening height target: 5.10 mm

The 5.10 mm height assumes a 4.50 mm hydrated-pack thickness plus 0.60 mm
allowance. Boveda does not guarantee that thickness, so test a fresh pack.
Do not enlarge the channel until the physical prototype shows that it binds.

### Silicone retention rings

The tray has **two grooves at the same Z height**. That is intentional for the
first prototype. Both are half-round/open-top seats sized for 2.0 mm round
silicone cord/O-rings. The two positions cross gaps between ventilation rows,
not the holes themselves.

Start with a 60 mm ID x 2 mm cross-section silicone O-ring if available. A
small 58/60/63 mm set is useful for finding the best preload. The goal is firm
friction on the thicker portion of the reed without bending it.

Reeds are inserted **tip-first**. There is no hard longitudinal reed stop in
this version; retention is provided by the silicone friction and the existing
tray geometry.

### Magnet/steel pockets

Every tray-face pocket is identical and is intentionally hardware-agnostic for
this prototype:

- nominal hardware: 4.00 mm diameter x 2.00 mm thick
- straight pocket: 4.20 mm diameter x 2.15 mm deep
- mouth lead-in: 0.15 mm chamfer

Do **not** commit to a polarity scheme yet. A later version can use magnets,
steel discs, or a mixture without changing the pocket geometry.

If you already own the hardware, press-fit it dry by hand. It should start
square at the chamfer and seat without hammering. Do not glue anything until
the magnetic architecture is decided.

## 3. Dry-assemble the tray

1. Place the core between face A and face B.
2. Keep the reed-tip borders aligned at the same end.
3. Check that the Boveda slides through the channel before applying adhesive.
4. Install two silicone O-rings around the assembled tray in the aligned
   grooves.
5. Test with sacrificial/low-value reeds first.
6. Only after all fit checks pass, bond the two faces to the core with a small
   amount of CA or epoxy away from ventilation apertures and the pack slot.

## 4. Later: full case

The full shell can still be exported with `make stl-all`, but the shell is
**not the print target of this revision**. The gasket/closure geometry still
needs its own physical validation/redesign pass before an expensive final
case print.

Before using a final case for valuable reeds, test the gasket, closure,
humidity stability, and shell airtightness separately. An FDM print is not
automatically airtight.
