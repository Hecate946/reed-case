# Magnets

## The part

**4 x 2 mm N52 neodymium disc, axially magnetised, Ni-Cu-Ni plated.**

Sold universally as "D4x2". Typical published specifications:

| Property | Value |
|---|---|
| Diameter | 4.0 mm, tolerance +/-0.1 mm |
| Thickness | 2.0 mm, tolerance +/-0.1 mm |
| Grade | N52 NdFeB |
| Magnetisation | Axial - poles on the flat faces |
| Coating | Nickel-copper-nickel, three layers |
| Max working temperature | 80 C / 176 F |

Also buy the same quantity of **4 x 2 mm mild steel discs** (sold as steel
discs, blank discs, or striker plates). They go in the opposite face. The
reason is in the Orientation section below.

### Where to buy

Amazon, N52 4 x 2 mm discs, 100 pack:
https://www.amazon.com/Small-Round-Disc-Magnets-4x2mm/dp/B0D6BCJCP7

Check the listing dimensions before ordering. "4x2" is the size you need;
4x1 and 4x3 are both sold under similar titles and neither fits the pocket.

Amazon does not reliably stock 4 x 2 mm plain steel discs. Magnet suppliers
do - search "steel disc 4mm" or "steel striker disc 4x2" at totalElement,
umagnets, or K&J. If you would rather not source a second part, see the
all-magnet fallback at the end of the Orientation section.

You need 8 magnets and 8 steel discs for a two-tray case. Buy extra: they are
cheap, brittle, and easy to lose.

Pull force for a D4x2 against steel is roughly 0.35-0.45 kg depending on
supplier. Four of them hold a tray weighing well under 50 g, so this is not a
close call - the size was chosen by what fits, not by what is strong enough.

### Why not 6 x 2 mm

6 x 2 mm is the more common hobby size and it is what three of the docs in
this repo previously specified. It does not fit, and the geometry says so
without much room for argument:

- Tray width is 92.4 mm, set by the case interior.
- Five passages at 14.5 mm clear plus six dividers consume 78.5 mm.
- That leaves 6.15 mm per side, and the ear has to clear the outer divider.

A 6 mm magnet needs a 6.2 mm pocket in an 8.4 mm ear, which pushes the pocket
1.25 mm into the outer reed passage. 5 mm misses by 0.15 mm. 4 mm clears by
0.95 mm, comfortably past the 0.25 mm `magnet_lane_clearance` guard.

`config.scad` now says 4 x 2 mm and so do the other documents. The
`tray_magnet_d` / `tray_magnet_h` values and the pocket asserts are the
authority; if you widen the case, re-run the asserts before assuming a bigger
magnet fits.

## Orientation

You asked for magnets that attach in any orientation. With permanent magnets
alone that is not achievable, and it is worth being clear about why rather
than shipping something that works half the time.

An axially magnetised disc has a north face and a south face. Two of them
attract only when opposite poles meet. If every face of every tray carried a
magnet, then two trays would attract in one relative orientation and push
apart in the other. Flipping a tray over reverses which pole is presented.
No arrangement of pole directions fixes this: whatever convention you adopt,
inverting one part inverts its poles with it.

**What is used instead: magnet on one face, steel on the other.** Steel has no
polarity. It is attracted to either pole equally, so the joint does not care
which way round anything is.

- `behn_tray_face_a` - passages 1 to 5 - takes four **magnets**.
- `behn_tray_face_b` - passages 6 to 10 - takes four **steel discs**.

The two faces use an identical pocket, so nothing about the print changes;
only what you drop in does. Build every tray the same way up - face A on top -
and any tray attaches to any other tray, at either rotation about the vertical
axis, because the four pockets sit at 2-fold rotational symmetry.

If you would rather buy only one part, you can put magnets in both faces
instead of steel in face B. Everything still works, but you then have to
respect polarity when stacking: face A of one tray only mates with face B of
the next, never with another face A. The steel version removes that rule.

The one case that still misbehaves is deliberately inverting a tray so that
two magnet faces meet. That is a magnet-to-magnet joint and it will attract or
repel depending on rotation. If you need that case to work too, put steel in
both faces of half your trays and magnets in both faces of the other half, and
alternate them in the stack.

## Pocket geometry

| Parameter | Value | Meaning |
|---|---|---|
| `tray_magnet_d` | 4.00 | nominal magnet diameter |
| `tray_magnet_h` | 2.00 | nominal magnet thickness |
| `magnet_d_clearance` | 0.20 | added to diameter, so a 4.20 mm pocket |
| `magnet_h_clearance` | 0.15 | added to depth, so a 2.15 mm pocket |
| `tray_border_w` | 6.40 | side border width, 1.1 mm wall each side of the pocket |
| `magnet_wall_min` | 1.00 | asserted minimum wall around the pocket |
| `tray_magnet_edge_inset` | 12.0 | pocket centre, measured in from each tray end |
| `magnet_lane_clearance` | 0.25 | minimum gap to the outer reed passage |

Pockets open at the outer surface of the tray, so the magnet sits flush and
the working face is not printed over.

They are **buried inside the side borders**, not in ears hanging off the
outline. The border was widened from 3.0 to 6.4 mm to make room: 4.2 mm of
pocket with 1.1 mm of wall inboard and 1.1 mm outboard, equal on both sides.
The tray outline is now a plain rounded rectangle with nothing protruding.

This is the main durability change. The old ears put the thinnest material in
the whole tray on the outside of the outline, where it takes every knock, and
a 1.1 mm ring of PLA around a magnet on a corner lobe is exactly what snaps
first. Inside the border it is supported on both sides by full-height wall.

Spacing: the four pockets sit 12 mm in from each tray end, 63.5 mm apart
along the tray, equal at both ends. Asserts enforce clearance from the
divider run-out at the heel and full wall thickness all round.

### Fitting them

1. Print the tolerance coupon and check the pocket before committing.
2. Seat each disc with the **same pole facing out on all four pockets of a
   given face**. Mark one face of your stock with a marker before you start:
   once they are in, you cannot tell. Getting one backwards means that corner
   pushes instead of pulls.
3. Press in by hand until flush. Do not hammer - they are brittle.
4. A drop of thin CA around the rim, not under the magnet, keeps it seated
   without adding height.
5. Steel discs go in face B the same way. They have no polarity, so no
   marking is needed.

The +/-0.1 mm magnet tolerance is comparable to the 0.20 mm diameter
clearance, so expect to test-fit. Print the tolerance coupon first. A pocket
that ends up loose is fixable with a drop of CA; one that ends up tight is not
worth forcing, since neodymium is brittle and the nickel plating chips.

Handle these away from your instrument. N52 discs will not damage grenadilla
or the keywork, but they will find any steel spring, tool, or card you own.
