# 4 x 2 mm tray hardware pockets

The **geometry is finalized first; the magnetic architecture is intentionally
not finalized yet.** Both tray faces use the same pocket, so the prototype can
be printed and tested before deciding whether a given location receives a
magnet, a steel disc, or nothing.

## Nominal hardware

The pocket is based on a common **4 x 2 mm disc** (`D4x2`). If magnets are used
later, N52 axially magnetized Ni-Cu-Ni neodymium discs are appropriate.
Matching 4 x 2 mm mild-steel discs can use the same cavity.

Current pocket geometry:

| Parameter | Value |
|---|---:|
| Nominal disc diameter | 4.00 mm |
| Nominal disc thickness | 2.00 mm |
| Straight pocket diameter | 4.20 mm |
| Straight pocket depth | 2.15 mm |
| Entry chamfer | 0.15 mm |
| Side border width | 6.40 mm |
| Straight-pocket wall each side | about 1.10 mm |
| Pocket center inset from each tray end | 12.0 mm |

The 0.15 mm mouth chamfer is only a lead-in. The working bore remains 4.20 mm,
so the disc is not intentionally loose once seated.

The pockets are buried in the side borders rather than placed in protruding
ears. That keeps the outline compact and puts material on both sides of the
pocket where the tray is most likely to be knocked.

## Why 4 x 2 mm instead of 6 x 2 mm

A 6 mm disc requires a pocket too wide for the current side-border/reed-lane
layout. The 4 mm nominal disc leaves the required wall and lane clearance in
the present 88.7 mm-wide tray body. The code asserts these clearances.

## Polarity: decide after the prototype

No polarity convention is required to print this version. Possible final
schemes include:

- magnet on one face, steel on the other;
- magnets on both faces with controlled polarity;
- magnets in the tray and steel targets in the outer case;
- selected pockets left empty.

Because the pocket geometry is identical on both faces, any of those choices
can be made later without reworking the tray dimensions.

For the first prototype, dry-fit the discs only. Do not glue magnets until the
tray-to-case behavior is chosen.
