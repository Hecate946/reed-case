# Alise CA100S-4P roller catch

Purchased part: Alise 40 mm silver double-roller catch, Amazon ASIN B0D8L6GJWK.
Model: **CA100S-4P**. Manufacturer part: **CA100-4P**.

Seller-published dimensions used by the CAD:

- Main mounting plate: **40 x 9 mm**
- Main mounting-hole pitch: **30 mm**
- Main roller/body span: **24 mm**
- Overall catch height: **10 mm**
- Published mounting-hole diameter: **4 mm**
- Striker mounting plate: **22 x 8 mm**
- Striker mounting-hole pitch: **15 mm**
- Striker tongue rise: **5 mm**

The listing also describes the nominal product envelope as 40 x 25 x 10 mm.
The detailed seller dimension image is used for the mounting plate geometry.
Plate thickness and small radii are not published; the OpenSCAD hardware model
uses preview-only approximations for those non-fit-critical details. Measure the
delivered parts before freezing a production revision.

The printed case has 2.5 mm pilot holes under both pieces. Adjust
`roller_catch_mount_pilot_d` and `roller_catch_strike_pilot_d` in `src/config.scad`
to match the screws you actually use.
