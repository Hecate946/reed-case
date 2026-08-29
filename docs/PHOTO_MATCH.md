# Matching the reference photographs

Four photographs were used as the visual reference for the tray:

1. A retail Behn tray pair, open case, viewed square-on.
2. A rendering of the previous version of this model, for comparison.
3. A printed tray held in the hand, reed-facing side up.
4. A printed tray viewed edge-on at the humidity-pack mouth.

None of the photographs contains a scale reference. What follows was matched
by **topology and proportion**, not by absolute dimension. Hole diameter, row
pitch, and divider thickness remain fitted values. If you want a true
dimensional match, measure a physical tray and update `src/config.scad`.

## Departures adopted from the photographs

| # | Observation | Change | Flag | Default |
|---|---|---|---|---|
| 1 | Retail tray carries an engraved number in each passage at the reed-tip end | Digits engraved into the vertical inner face of the reed tip stop | `lane_numbers_enable` | `true` |
| 2 | Patent Fig. 4 element 152 shows two rails per passage over the lower half | Rounded longitudinal rails, stopping at the 11.5th row | `stock_rails_enable` | `true` |
| 3 | Tray edge is solid above and below the pack mouth | Reed-facing sheet runs to the insertion edge | `front_plane_cutout_enable` | `false` |
| 4 | Dividers run the whole tray length | Guide walls extended and trimmed to the outline | `guide_walls_full_length` | `true` |

### 1. Passage numbers

In the retail photograph the digits stand upright while the apertures beside
them are foreshortened into ellipses. That puts them on the vertical inner
face of the reed tip stop, not on the floor, and that is where they are cut.

The wall is only `tray_guide_h` (4.2 mm) tall, so `lane_number_size` is 2.6 mm
with `lane_number_margin` (0.8 mm) of clear wall above and below.
`lane_number_depth` (0.5 mm) cuts back into a 9 mm thick stop.

The glyphs are placed with `rotate([90, 0, 0])`, which maps the glyph's own +x
onto world +X and its +y onto world +Z - upright and left-to-right for an
observer at the heel end. That rotation sends the extrusion to -Y, so the
block is set one depth proud of the wall and cuts back into it.

Three asserts fail the build if the digits are too tall for the wall, too wide
for the passage, or deeper than 1.5 mm.

The font string is resolved by fontconfig at render time. If your machine does
not have Liberation Sans, OpenSCAD silently substitutes another face and the
digits will still cut, just in a different shape. Set `lane_number_font` to
something you actually have installed if that matters to you.

### 2. Stock rails

Fig. 4 element 152. Two rails per passage, each midway between adjacent
aperture columns so it runs tangent to the softened hole rims rather than
across them. The column gap is 1.96 mm and `rail_w` is 2.0 mm, which is why
they just kiss the rims as they do in the figure.

They begin half a row pitch below the first aperture, 1.2 mm from the heel
edge, and stop at the midpoint between rows 11 and 12 - the 11.5th row -
covering exactly half of the 22-row field. `rail_rows` sets that stop.

The profile is a hull of two flattened spheres: a rounded crown 2.0 mm wide
and 0.55 mm tall, with domed ends.

Note that the retail and printed trays in the photographs show flat passage
floors with no visible rails. The patent figure and the photographs disagree
here; the figure was followed. `stock_rails_enable = false` reverts it.

### 3. Aperture field

Because the sheet is no longer cut away at the insertion end, the ventilation
field was rebased so it runs nearly the full passage length as it does in the
photographs.

The reed heel line and the tip stop are now derived from the tray edge, and
the aperture field is derived from those two lines. Previously the dependency
ran the other way: the tip stop was computed from the aperture field, which in
turn was computed from a fixed inset. That ordering made it impossible to
extend the field without also moving the tip stop.

With the numbers moved onto the stop wall, the floor space the old label zone
reserved was freed and the field now runs close to both borders as it does in
Fig. 4. `aperture_heel_margin` (2.0 mm) and `aperture_tip_margin` (1.2 mm) set
the clear material left at each end.

For the `behn_premium20` preset the field is now y = -40.77 to 32.57 mm,
73.34 mm long. It was 66 mm in the original and 63.92 mm at the intermediate
step.

Row count is held at the documented 22, so the pitch stretched from 3.04 to
3.49 mm and the field reads slightly sparser than the photograph. Raise
`tray_air_rows` to about 25 if you would rather keep the original density than
the documented count.

## Deliberately not changed

**Tip-stop depth.** The solid band at the reed-tip end is about 9 mm deep in
this model and looks closer to 5-6 mm in the retail photograph. It is set by
`reed_end_margin` (6.0 mm), which is a reed-fit parameter. Measure your reeds
and set it against them rather than against a photograph. Note that this band
is also what carries the engraved numbers, so shortening it does not affect
them - only `tray_guide_h` does.

**Hole diameter and pitch.** `tray_air_hole_d` is still the fitted 1.6 mm.
The ratio of pitch to diameter in the model (about 1.9:1) is close to what the
retail photograph shows, which is as much as an unscaled image supports.

**Corner ear geometry.** The photographs show a circular feature in each
corner ear, consistent with the existing magnet pockets. Whether the retail
part uses a blind pocket or a through hole cannot be told from these images.

## Second-face orientation

`behn_tray()` previously placed the lower face with `mirror([0, 0, 1])`. A
reflection is not a physical operation, so that described an assembly that
cannot be built from one printed part. It was harmless only because every
feature was symmetric in X.

The engraved numbers break that symmetry, so the lower face is now placed with
`rotate([0, 180, 0])`. This is a real rotation about the long axis: the same
printed part, rolled over, with the reed-tip end still at the reed-tip end.
Roll the assembled tray over the same way and the numbering reads correctly on
both faces. Flipping it end-for-end instead puts the digits upside down.

## Divider run-out

The photographed tray takes each divider and side frame gradually down to the
floor at the open heel end rather than stopping in a square corner.

`guide_end_taper` sets the horizontal run of that round. The profile is a
quarter arc tangent to the top of the wall inboard, meeting the floor
VERTICALLY at the tray edge, cut as a single polygon swept along X.

The direction matters. The first attempt used the opposite arc - tangent to
the floor - which faired the divider out to a feather edge: a long, thin,
fragile point that no slicer will render sensibly. The arc used now leaves a
rounded nose instead. At 0.2 mm in from the edge the wall is already 1.28 mm
tall, so there is material to print.

`guide_end_taper` defaults to `tray_guide_h`, which makes it a true circular
quarter round. Larger values stretch it into an ellipse for a longer, more
gradual run. Set it to 0 for square ends.

## Borders

The three closed borders - two sides and the reed tip end - are plain
rectangular solids of equal width, all driven from `tray_border_w`.

The side frames were a hull of four circles, which produced a rounded stadium
outline. That shape was doing nothing the body's own corner radius was not
already doing, and it read as a bulge rather than a border. They are now two
rectangles filling the gap between the outer guide wall and the body edge,
intersected with the body outline so the ends still pick up the corner radius.

The reed tip border was a solid block running from the reed tip line all the
way out to the tray edge, about 9 mm of material. It has three jobs: stop the
reed tip, carry the engraved numbers, and tie the six dividers together. A
wall does all three, so it is now a `tray_border_w` wall sitting at the tray
edge, intersected with the body outline exactly like the side frames, closing
the three borders into a U.

Because the border is at the edge rather than at the reed tip line, the reed
is located from the tip inwards and the leftover depth collects at the open
heel end: 13.5 mm on `behn_premium20`. That is where you reach in to lift a
reed out, so it is usable space rather than dead space, but the reed can slide
that far back if the elastic band is off.

`tray_border_w` is derived, not set. `tray_border_w_min` (3.0 mm) is the
floor; the body width is the guide span plus that minimum each side, unless
the humidity-pack channel needs more. On `behn_premium20` the guide span wins
and the borders come out at exactly 3.0 mm. On `size60_studio` the Boveda 320
channel forces a 138.35 mm body against a 111.3 mm guide span, so all three
borders come out at 13.5 mm. They are still equal, which is the requirement,
but that preset is carrying a wide frame for the sake of the pack. Raising
`reeds_per_face` or narrowing the pack is what would tighten it.

The magnet ears stay as full-height circles. They cannot be reduced to the
sheet thickness because the pocket is deeper than the sheet.

## Reed envelope

Bb and A clarinet share a reed; no separate A-clarinet cut is manufactured.
Published soprano Bb figures cluster at 67-70 mm long, 11.5-13 mm at the tip
and 2.8-3.2 mm at the heel.

The configured envelope is 70.5 x 13.4 x 3.30 mm, each value carrying
clearance over the largest published figure. The case needed no scaling: at
92.4 x 87.5 mm of tray, the passages were already generous. Measure your own
stock and tighten `reed_max_w` if you want less side play.

## Band grooves

Two grooves, sized for round elastic cord rather than a flat band.

`elastic_band_d` (2.0 mm) is the cord diameter and `elastic_band_clearance`
(0.25 mm) is added to the radius. The groove is a half-round seat whose
centre sits `elastic_band_seat_depth` (0.35 mm) below a plain half-round, with
the material above it squared off so the mouth opens to the top face. The cord
therefore drops in from above with no undercut to snap past, and once in, its
top sits 0.6 mm below the wall tops so it cannot roll off.

Cut depth is 2.85 mm into a 4.2 mm wall, leaving 1.35 mm of divider beneath
the groove. An assert guards that.

`elastic_band_row_gaps` places them. The values are 1-indexed row gaps
counting apertures from the heel end, so 8.5 means "between holes 8 and 9".
The current setting is `[8.5, 11.5]`.

Note that these two are 10.85 mm apart on a 70.5 mm reed and both sit below
the centre of the field. Symmetric thirds would be `[8.0, 15.0]`.
