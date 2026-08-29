/*
  Central configuration.

  VERIFIED PUBLIC BEHN VALUES
  - Premium 20 exterior body: 1.50 x 4.00 x 4.00 in
  - PLA construction, gasket-sealed, perforated/railed trays
  - two magnetically attached 10-reed trays, 72% Boveda per tray

  All other dimensions below are original engineering starting values.
*/

assert(preset == "behn_premium20" || preset == "size60_studio" ||
       preset == "hecate946",
       str("Unknown preset: ", preset));

// Mesh/export profile.  The library FDM profile keeps every functional
// dimension identical, but skips sub-nozzle cosmetic hole-rim relief and uses
// sensible segment counts so OpenSCAD 2021 can export the tray quickly.
print_profile = is_undef(print_profile) ? "production" : print_profile;
assert(print_profile == "production" || print_profile == "library_fdm",
       str("Unknown print_profile: ", print_profile));
is_library_fdm = print_profile == "library_fdm";

inch = 25.4;
$fn = is_library_fdm ? 20 : ($preview ? 48 : 96);
epsilon = 0.02;

is_size60 = preset == "size60_studio";
is_hecate946 = preset == "hecate946";

// Hinge dimensions are declared early because the shell body is shortened so
// the external barrel remains inside the requested overall depth envelope.
hinge_outer_d = 5.6;
hinge_pin_d = 1.75;
hinge_pin_clearance = 0.22;
hinge_overlap = 0.70;

// Overall closed shell envelope (hinge included; pin head/latch clip excluded).
case_w = is_size60 ? 151.0 : 4.00 * inch;
case_d = is_size60 ? 124.0 : 4.00 * inch;
case_h = is_size60 ? 48.0 : 1.50 * inch;
base_h = case_h / 2;
lid_h = case_h - base_h;
corner_r = is_size60 ? 9.0 : 7.0;
body_d = case_d - hinge_outer_d + hinge_overlap;
body_y = (case_d - body_d) / 2;

// Shell and printer fit.
wall = 2.4;
floor_t = 2.4;
printer_clearance = 0.25;
elephant_foot_relief = 0.25;

// Airtight seal: 2 mm closed-cell silicone cord is the intended consumable.
gasket_d = 2.0;
gasket_groove_w = 2.35;
gasket_groove_d = 1.30;
gasket_compression = 0.25; // fraction of nominal diameter, target 20-30%
seal_inset = wall + 2.2;
seal_tongue_w = 1.15;
seal_tongue_h = 0.55;

// Humidity pack. Official face sizes; pack thickness is a measured/estimated
// allowance and should be checked against the actual pack before printing.
boveda_w = is_size60 ? 133.35 : 69.85;
boveda_d = is_size60 ? 88.90 : 63.50;
boveda_h = is_size60 ? 8.0 : 4.5;
boveda_clearance = 1.0;
boveda_slide_clearance = 1.0;

// US12103755B2-style double-sided tray. Two complete trays stack in the case;
// each contains its own humidity pack and holds reeds on both faces.
tray_count = 2;
reeds_per_face = is_size60 ? 7 : 5;
total_reed_capacity = tray_count * 2 * reeds_per_face;
tray_side_gap = 2.2;
tray_w = case_w - 2 * (wall + tray_side_gap);
tray_d = body_d - 2 * (wall + tray_side_gap);
tray_corner_r = 3.0;
tray_face_t = 1.20;
boveda_thickness_clearance = 0.60;
tray_core_h = boveda_h + boveda_thickness_clearance;
tray_pack_opening_w = boveda_w + 2 * boveda_clearance;
tray_pack_opening_h = tray_core_h;
tray_guide_h = 4.20;
tray_guide_t = 1.10;
// Only the INTERNAL lane dividers are separate guide walls. The left and
// rightmost reed passages terminate directly at the structural side borders;
// there is no redundant outer divider between a passage and its edge wall.
// This saves 1.60 mm per side versus the earlier prototype while keeping
// every reed passage at the exact same clear width.
reed_slot_clear_w = 14.30;
tray_passage_field_w = reeds_per_face * reed_slot_clear_w +
                       max(reeds_per_face - 1, 0) * tray_guide_t;
tray_side_wall_w = (tray_w - tray_passage_field_w) / 2;
tray_stack_gap = 0.25;
// Physical Behn tray reference: 22 small apertures per column. The photograph
// has no absolute scale, so 1.6 mm is the fitted starting diameter.
tray_air_hole_d = 1.60;
tray_air_rows = 22;
tray_air_columns = 3;
tray_air_column_pitch = 4.30;
tray_air_edge_relief = 0.18;   // radial softening at the reed-facing edge
tray_air_edge_relief_h = 0.30; // printable micro-chamfer depth
tray_air_edge_steps = 2;
tray_platform_top_chamfer = 0.20; // soften the exposed platform rim
tray_wall_top_chamfer = 0.20;     // soften guide/side/tip-wall top edges
tray_feature_fuse_overlap = 0.10; // raised walls overlap the sheet; avoids zero-thickness STL seams
tray_reed_plane_edge_margin = 1.25;
// Blind side-loading slot: the pack enters from the raised reed-tip-frame end
// (+Y), travels only its own depth plus 1 mm, then contacts narrow support
// ribs aligned beneath the reed-guide walls.
tray_pack_slot_depth = boveda_d + boveda_slide_clearance;
tray_pack_stop_y = tray_d / 2 - tray_pack_slot_depth;
tray_pack_seated_y = tray_d / 2 - boveda_slide_clearance - boveda_d / 2;
tray_pack_vent_clearance = 0.25;
tray_pack_support_w = 1.60;
tray_core_heel_bridge_d = 2.00; // joins core side rails behind the first vent row
// Core mouth ends are now true semicircular caps whose radius is derived
// automatically from the side-rail width.  No separate mouth-radius tuning
// parameter is required.

// Bb/Eb clarinet reed design envelope. Measure your own reeds before finalizing.
// Bb and A clarinet take the same reed; no separate A-clarinet cut is made.
// Published soprano Bb figures cluster at 67-70 mm long, 11.5-13 mm wide at
// the tip and 2.8-3.2 mm at the heel. These are envelope values, i.e. the
// largest reed the passage must accept, so each carries clearance over the
// largest published figure. Measure your own stock and tighten if you like.
reed_length = 70.5;
reed_max_w = 13.4;
reed_max_h = 3.30;
reed_end_margin = 7.5;
reed_tip_clearance = 0.50;
rail_h = 0.55;
rail_w = 2.00;
rail_count = 2;
rail_rows = 11; // rails cover the lower 11 of the 22 aperture rows

// ---------------------------------------------------------------------------
// Reference-photograph match
//
// The four supplied photographs (retail tray, printed tray rear face, printed
// tray edge) show three departures from the earlier patent-literal geometry.
// Each is a flag so the previous behaviour can be restored in one edit.
// ---------------------------------------------------------------------------

// The retail tray carries an engraved passage number at the reed-tip end of
// every passage. In the photograph the digits stand upright while the
// apertures beside them are foreshortened into ellipses, so they sit on the
// vertical inner face of the reed tip stop, not on the floor. The available
// height is therefore tray_guide_h, which is what caps lane_number_size.
lane_numbers_enable = true;
lane_number_size = 2.60;    // nominal cap height passed to text()
lane_number_depth = 0.50;   // engraved recess depth into the stop wall
lane_number_margin = 0.80;  // minimum clear wall above and below a digit
lane_number_font = "Liberation Sans:style=Bold";

// Two rounded longitudinal rails per passage, Fig. 4 element 152. They begin
// at the heel edge and stop halfway between aperture rows 11 and 12, so they
// run under exactly half of the 22-row field.
stock_rails_enable = true;

// The photographed tray edge is solid above and below the humidity-pack
// mouth, so the reed-facing sheet is not cut away at the insertion end.
front_plane_cutout_enable = false;

// With the sheet solid, the passage dividers run the full tray length as they
// do in the photographs instead of stopping at the old cutout edge.
guide_walls_full_length = true;

// Clear floor left between the softened aperture edge and each end of the
// passage. Moving the numbers off the floor freed the space the old label
// zone reserved, so the field now runs close to both borders as in Fig. 4.
aperture_heel_margin = 2.00;  // to the open heel edge of the tray
aperture_tip_margin = 1.20;   // to the inner face of the reed tip stop
// Round-section elastic cord, not a flat band. The groove is a half-round
// seat cut a little deeper than the cord radius so the cord sits below the
// wall top and cannot roll off, while staying free of a true undercut.
elastic_band_d = 2.00;           // cord diameter
elastic_band_clearance = 0.25;   // added to the radius
elastic_band_seat_depth = 0.35;  // extra depth below the half-round

// Which aperture row gap each band crosses, counting holes from the heel end
// starting at 1. 8.5 means "between holes 8 and 9".
elastic_band_row_gaps = [8.5, 11.5];

// Horizontal run of the rounded end on every divider and side frame at the
// open heel end. The profile is a quarter arc tangent to the reed plane at
// the opening and turning upward into the full-height wall inboard. Equal to
// tray_guide_h it is a true circle; larger values stretch it into an ellipse.
// Set to 0 for square ends.
guide_end_taper = tray_guide_h;

// Floor on the width of the three closed borders. The actual figure,
// tray_border_w, is derived from the body width further down, because on the
// larger preset the humidity-pack channel needs a wider body than this
// minimum would give and the borders have to follow it. Either way all three
// borders end up the same width. The heel end stays open.
// Wide enough to bury a magnet pocket with a full wall on both sides:
// pocket diameter 4.20 plus 1.10 mm each side. The pockets used to sit in
// ears that stuck out past the body, which put the thinnest material of the
// whole tray on the outside where it takes the knocks. Burying them inside
// the border is the single biggest durability change available here.
tray_border_w_min = 6.40;

// Compact hardware pockets are buried in the side borders, fully outside
// the clear reed passages.
// Hardware: 4 x 2 mm N52 neodymium disc, axially magnetised, Ni-Cu-Ni
// plated, typical tolerance +/-0.1 mm. Sold everywhere as "D4x2".
//
// Both faces take the SAME pocket, so each location can later accept either
// a 4 x 2 mm magnet or a matching mild-steel disc. Polarity/hardware layout
// is intentionally deferred until after the physical tray prototype.
tray_magnet_d = 4.0;
tray_magnet_h = 2.0;
magnet_d_clearance = 0.20;
magnet_h_clearance = 0.15;
magnet_entry_chamfer = 0.15; // small lead-in; straight pocket remains 4.20 mm
magnet_lane_clearance = 0.25;
magnet_wall_min = 1.00;
// Distance from each tray end to the pocket centre. Equal at both ends, so
// the four pockets sit on a rectangle centred on the tray and a tray mates
// with another at either rotation about Z.
tray_magnet_edge_inset = 12.0;
tray_magnet_y = tray_d / 2 - tray_magnet_edge_inset;
tray_core_side_wall_min = 1.50;
// The side borders themselves now form the outside walls of the two outer
// reed passages. Therefore body width is simply the clear passage field plus
// one structural/magnet border per side. The humidity-pack envelope can still
// force a wider body on the large preset.
tray_body_w = max(tray_passage_field_w + 2 * tray_border_w_min,
                  boveda_w + 2 * boveda_clearance +
                  2 * tray_core_side_wall_min);

// Whatever the body width came out as, all three closed borders use this
// width. The default is 6.40 mm so a D4x2 pocket stays protected.
tray_border_w = (tray_body_w - tray_passage_field_w) / 2;

// Centred in the side border, so the wall is the same thickness inboard and
// outboard of the magnet. No ears, no protrusions: the tray outline is a
// plain rounded rectangle.
tray_magnet_x = (tray_body_w - tray_border_w) / 2;
tray_body_corner_r = min(
    tray_corner_r,
    max(tray_border_w - 0.50, 0.50)
);

// Hinge. The rear edge of the barrel defines the overall case depth.
hinge_edge_margin = 7.0;
hinge_center_len = case_w * 0.38;
hinge_knuckle_gap = 0.55;

// Optional removable front latch.
latch_w = is_size60 ? 24.0 : 20.0;
latch_t = 2.0;
latch_clearance = 0.30;
latch_lug_depth = 2.2;
latch_lug_h = 2.0;

// Visual separation used only in assembly/exploded previews.
exploded_gap = is_size60 ? 18 : 14;

// Feasibility assertions fail early instead of silently producing bad parts.
assert(case_w > boveda_w + 2 * (wall + boveda_clearance),
       "Humidity pack is too wide for this case preset");
assert(body_d > boveda_d + 2 * (wall + boveda_clearance),
       "Humidity pack is too deep for this case preset");
assert(tray_w / reeds_per_face > reed_max_w + 1.0,
       "Reed passages are too narrow; reduce reeds_per_face or grow the case");
assert(gasket_groove_d < wall, "Gasket groove would break through the rim");
assert(tray_guide_h >= rail_h + reed_max_h,
       "Guide walls must protect reeds when the trays are stacked");
assert(tray_feature_fuse_overlap > 0 && tray_feature_fuse_overlap < tray_face_t / 2,
       "Tray feature fuse overlap must be positive and stay within the face sheet");
assert(reed_slot_clear_w >= reed_max_w + 0.4,
       "Reed passages need at least 0.4 mm total width clearance");
assert(tray_side_wall_w > 0,
       "Configured reed passages do not fit within the tray width");
assert(tray_border_w >= tray_border_w_min - 0.01,
       str("Borders came out at ", tray_border_w, " mm, under the ",
           tray_border_w_min, " mm minimum"));
assert(tray_body_w <= tray_w,
       "Humidity channel and minimum side walls exceed the tray width");
assert(rail_rows > 0 && rail_rows <= tray_air_rows / 2,
       "Rail coverage must not extend beyond half of the aperture rows");
assert(abs(tray_magnet_x) + tray_border_w / 2 <= tray_w / 2,
       "Tray corner tab exceeds the tray width");
assert(abs(tray_magnet_y) + tray_border_w / 2 <= tray_d / 2,
       "Tray corner tab exceeds the tray depth");
assert(tray_magnet_y - (tray_magnet_d + magnet_d_clearance) / 2 >
       -tray_d / 2 + guide_end_taper + magnet_wall_min,
       "Magnet pocket overlaps the divider run-out at the heel end");
assert(tray_border_w >= tray_magnet_d + magnet_d_clearance +
                        2 * magnet_wall_min,
       str("Side border is ", tray_border_w, " mm: too narrow to bury a ",
           tray_magnet_d, " mm magnet with ", magnet_wall_min,
           " mm of wall on each side"));
assert(elastic_band_d / 2 + elastic_band_clearance +
       elastic_band_seat_depth < tray_guide_h - 1.0,
       "Band groove would leave less than 1 mm of divider beneath it");
assert(tray_magnet_h + magnet_h_clearance < tray_face_t + tray_guide_h - 1.0,
       "Magnet pocket would leave less than 1 mm of floor beneath it");
assert((tray_magnet_d + magnet_d_clearance) / 2 + magnet_wall_min <=
       tray_border_w / 2,
       "Magnet pocket leaves less than 1 mm around the corner tab");
assert((tray_magnet_d + magnet_d_clearance + 2 * magnet_entry_chamfer) / 2 +
       (magnet_wall_min - magnet_entry_chamfer) <= tray_border_w / 2,
       "Magnet entry chamfer over-cuts the side border");
assert(tray_magnet_x - (tray_magnet_d + magnet_d_clearance) / 2 >=
       tray_passage_field_w / 2 + magnet_lane_clearance,
       "Magnet pocket intrudes into a reed passage");
// reed_end_margin is now a MINIMUM on the open heel end, not a placement
// value: the reed is located from the tip border inwards, so whatever is left
// over collects at the heel.
assert(tray_d >= reed_length + reed_tip_clearance + tray_border_w +
                 reed_end_margin,
       "Tray is too short for the configured reed envelope");
assert(!lane_numbers_enable ||
       lane_number_size <= tray_guide_h - 2 * lane_number_margin,
       str("Passage numbers do not fit the ", tray_guide_h,
           " mm tip-stop wall with ", lane_number_margin,
           " mm clear above and below"));
assert(!lane_numbers_enable || lane_number_depth <= 1.50,
       "Engraved passage numbers deeper than 1.5 mm weaken the tip stop");
assert(!lane_numbers_enable || lane_number_size < reed_slot_clear_w - 2.0,
       "Passage numbers are too large for the passage width");
assert(tray_body_w >= boveda_w + 2 * boveda_clearance +
                      2 * tray_core_side_wall_min,
       "Humidity pack is too wide for the tray recess");
assert(tray_pack_stop_y > -tray_d / 2 + tray_pack_support_w,
       "Humidity-pack stop ribs need positive length");
assert(tray_core_heel_bridge_d > 0 &&
       tray_core_heel_bridge_d <= aperture_heel_margin + 0.01,
       "Core heel bridge must stay behind the first ventilation row");

tray_total_h = tray_core_h + 2 * (tray_face_t + tray_guide_h);
loaded_stack_h = tray_count * tray_total_h
               + (tray_count - 1) * tray_stack_gap;
case_internal_h = case_h - 2 * floor_t;
assert(loaded_stack_h <= case_internal_h,
       str("Two loaded patent trays are ", loaded_stack_h - case_internal_h,
           " mm too tall for the closed case"));

// ---------------------------------------------------------------------------
// HECATE946 SIDE-BY-SIDE CASE
// ---------------------------------------------------------------------------
// This enclosure is deliberately independent of the historical Premium-20
// shell. It carries TWO of the exact current five-lane double-sided trays
// side-by-side in shallow registration wells, plus a provisional hygrometer
// bay at the far left. The tray geometry above is unchanged.
//
// The 214 mm width was chosen intentionally: it keeps the whole base/lid
// inside a nominal 220 x 220 mm hobby-printer bed while fitting two 88.70 mm
// trays side-by-side. Always confirm the library printer's usable area before
// starting a long print; skirts/brims may require a little extra room.
hecate_case_w = 214.0;
hecate_body_d = 97.0;
hecate_case_h = 25.0;
hecate_base_h = hecate_case_h / 2;
hecate_lid_h = hecate_case_h - hecate_base_h;
hecate_corner_r = 8.0;
hecate_wall = 3.20;
hecate_floor_t = 4.00;

// Shallow tray registration wells. 0.40 mm clearance on every side is a
// deliberately forgiving FDM prototype fit; magnets do the actual retention.
hecate_tray_xy_clearance = 0.40;
hecate_tray_recess_depth = 0.60;
hecate_tray_recess_w = tray_body_w + 2 * hecate_tray_xy_clearance;
hecate_tray_recess_d = tray_d + 2 * hecate_tray_xy_clearance;
hecate_tray_recess_r = tray_body_corner_r + hecate_tray_xy_clearance;
hecate_between_trays = 2.40;
hecate_hygro_to_tray_gap = 2.40;

// Placeholder only; this is intentionally easy to edit once the exact
// humidity-reader model is chosen. The long dimension runs front-to-back so
// even a narrow left strip can accept a useful display module later.
hecate_hygro_slot_w = 22.0;
hecate_hygro_slot_d = 50.0;
hecate_hygro_recess_depth = 0.80;
hecate_hygro_corner_r = 2.5;

// Solve the side-by-side layout from the LEFT interior wall.  The remaining
// 2.6 mm of interior width is split equally as edge margin, so nothing is
// hard-coded to the old case centreline.
hecate_inner_w = hecate_case_w - 2 * hecate_wall;
hecate_layout_used_w = hecate_hygro_slot_w + hecate_hygro_to_tray_gap +
                       2 * hecate_tray_recess_w + hecate_between_trays;
hecate_layout_side_margin = (hecate_inner_w - hecate_layout_used_w) / 2;
hecate_inner_left_x = -hecate_case_w / 2 + hecate_wall;
hecate_hygro_x = hecate_inner_left_x + hecate_layout_side_margin +
                 hecate_hygro_slot_w / 2;
hecate_tray1_x = hecate_inner_left_x + hecate_layout_side_margin +
                 hecate_hygro_slot_w + hecate_hygro_to_tray_gap +
                 hecate_tray_recess_w / 2;
hecate_tray2_x = hecate_tray1_x + hecate_tray_recess_w +
                 hecate_between_trays;
hecate_tray_y = 0;

// Structural partitions make the three interior zones visually and
// mechanically distinct. Each wall is centered in an existing 2.40 mm gap,
// runs front-to-back, and fuses into the cup walls for stiffness.
// Full-height structural partitions. They rise from the interior floor all
// the way to the base seam and brace the wide HECATE946 shell.
// 2.20 mm thickness stays inside the existing 2.40 mm inter-bay gaps, leaving
// 0.10 mm between each partition and each locating-well cut. Because every
// tray already has 0.40 mm clearance inside its well, the physical tray still
// has about 0.50 mm clearance to the partition on each side.
hecate_divider_t = 2.20;
hecate_divider_h = hecate_base_h - hecate_floor_t;
hecate_divider_r = 0.55;
hecate_inner_d = hecate_body_d - 2 * hecate_wall;

hecate_hygro_right_x = hecate_hygro_x + hecate_hygro_slot_w / 2;
hecate_tray1_left_x = hecate_tray1_x - hecate_tray_recess_w / 2;
hecate_tray1_right_x = hecate_tray1_x + hecate_tray_recess_w / 2;
hecate_tray2_left_x = hecate_tray2_x - hecate_tray_recess_w / 2;

hecate_hygro_divider_x = (hecate_hygro_right_x + hecate_tray1_left_x) / 2;
hecate_tray_divider_x = (hecate_tray1_right_x + hecate_tray2_left_x) / 2;

// Hardware pockets in the CASE FLOOR use the same D4x2 geometry as the tray.
// This keeps the polarity/material choice open: magnet, steel disc, or empty.
// The pocket mouths are in the bottom of each registration well, exactly
// below the tray's four existing hardware locations.
hecate_floor_magnet_depth = tray_magnet_h + magnet_h_clearance;

// Minimal snap-on metal-pin hinge.
//
// A common 2.0 mm stainless rod / music wire is retained by four short base
// barrels. Three C-shaped clips on the lid snap over the exposed rod between
// those supports. This removes the old nearly full-width printed barrel while
// preserving a metal bearing surface and a replaceable/detachable lid.
//
// The production clip has a 2.35 mm running bore around the 2.0 mm pin and a
// 1.55 mm mouth. PETG/nylon is recommended for repeated snap-on removal; PLA
// is suitable for a fit prototype but is more likely to fatigue at the lips.
hecate_hinge_pin_d = 2.0;
hecate_hinge_pin_len = 190.0;      // cut from an easy-to-find 200 mm rod
hecate_hinge_bore_d = 2.25;       // base support-barrel running bore
hecate_hinge_support_outer_d = 6.0;
hecate_hinge_support_len = 10.0;
hecate_hinge_support_xs = [-86.0, -29.0, 29.0, 86.0];
hecate_hinge_clip_outer_d = 6.4;
hecate_hinge_clip_bore_d = 2.35;
hecate_hinge_clip_len = 14.0;
hecate_hinge_clip_xs = [-58.0, 0.0, 58.0];
hecate_hinge_clip_mouth = 1.55;
hecate_hinge_wall_gap = 0.25;
hecate_hinge_root_h = 2.20;
hecate_hinge_root_depth = 1.15;
// Keep every rotating hinge surface outside the case wall so the base and lid
// do not require large relief cutouts at the seam. Short roots connect each
// bearing/clip to its own shell on the correct side of the seam.
hecate_hinge_y = -hecate_body_d / 2 - hecate_hinge_clip_outer_d / 2 -
                 hecate_hinge_wall_gap;
hecate_case_overall_d = hecate_body_d + hecate_hinge_clip_outer_d +
                        hecate_hinge_wall_gap;

// Seal: standard CLOSED metric silicone O-ring rather than cut cord.
// Target hardware is 185 mm ID x 2 mm cross-section ("2x185" VMQ silicone),
// a standard metric size. On this rounded-rectangle path its centreline is
// stretched about 1.8%, enough to keep the ring seated without excessive
// tension. The 1.50 mm groove depth leaves 0.50 mm proud, producing ~25%
// axial compression against the flat base rim at full latch engagement.
hecate_gasket_id = 185.0;
hecate_gasket_d = 2.0;
hecate_gasket_groove_w = 2.20;
hecate_gasket_groove_d = 1.50;
hecate_gasket_outer_inset = 0.50;

// Neutral-axis length check for the closed O-ring. For a rounded rectangle,
// P = 2(w + d - 4r) + 2*pi*r. The centre of the 2.20 mm groove is used as
// the working path. A 2x185 ring lands at roughly 1.8% installed stretch.
hecate_gasket_path_w = hecate_case_w - 2 * hecate_gasket_outer_inset -
                       hecate_gasket_groove_w;
hecate_gasket_path_d = hecate_body_d - 2 * hecate_gasket_outer_inset -
                       hecate_gasket_groove_w;
hecate_gasket_path_r = hecate_corner_r - hecate_gasket_outer_inset -
                       hecate_gasket_groove_w / 2;
hecate_gasket_path_len =
    2 * (hecate_gasket_path_w + hecate_gasket_path_d -
         4 * hecate_gasket_path_r) +
    2 * PI * hecate_gasket_path_r;
hecate_gasket_free_center_len = PI * (hecate_gasket_id + hecate_gasket_d);
hecate_gasket_stretch = hecate_gasket_path_len /
                        hecate_gasket_free_center_len - 1;

// Two independent front snap latches distribute seal compression across the
// long case. The final hook/catch dimensions are intentionally conservative
// for a first FDM print; PETG/nylon will tolerate repeated flexing better than
// brittle PLA in a final functional enclosure.
hecate_latch_xs = [-54.0, 54.0];
hecate_latch_arm_w = 14.0;
hecate_latch_arm_t = 1.60;
hecate_latch_arm_len = 5.00;
hecate_latch_hook_depth = 1.60;
hecate_latch_hook_h = 1.70;
hecate_latch_catch_depth = 1.80;
hecate_latch_catch_h = 1.50;
hecate_latch_preload = 0.35;
hecate_latch_clearance = 0.30;

// The complete tray's lowest point is the top of the guide walls on its
// downward-facing face. This translation seats that point on the well floor.
hecate_tray_bottom_offset = tray_face_t + tray_guide_h;
hecate_tray_seated_z = hecate_floor_t - hecate_tray_recess_depth +
                       hecate_tray_bottom_offset;
hecate_lid_inside_roof_z = hecate_case_h - hecate_floor_t;
hecate_tray_top_z = hecate_floor_t - hecate_tray_recess_depth + tray_total_h;

assert(hecate_layout_side_margin >= 0.89,
       "HECATE946 layout is too wide for the 214 mm shell");
assert(hecate_between_trays + 0.01 >= hecate_divider_t,
       "HECATE946 centre divider intrudes into a tray locating well");
assert(hecate_hygro_to_tray_gap + 0.01 >= hecate_divider_t,
       "HECATE946 hygrometer divider intrudes into a neighboring well");
assert(hecate_divider_h > 0 &&
       abs(hecate_floor_t + hecate_divider_h - hecate_base_h) < 0.01,
       "HECATE946 divider must terminate exactly at the base seam");
assert(hecate_tray_recess_d <= hecate_body_d - 2 * hecate_wall,
       "HECATE946 tray wells do not fit front-to-back");
assert(hecate_floor_t - hecate_tray_recess_depth -
       hecate_floor_magnet_depth >= 1.15,
       "HECATE946 floor magnet pockets leave too little bottom skin");
assert(hecate_tray_top_z + 1.0 <= hecate_lid_inside_roof_z,
       "HECATE946 lid does not clear the seated trays");
assert(hecate_gasket_groove_d < hecate_lid_h - hecate_floor_t,
       "HECATE946 gasket groove is too deep");
assert(hecate_gasket_stretch >= 0.01 && hecate_gasket_stretch <= 0.05,
       str("HECATE946 2x185 silicone O-ring stretch is ",
           hecate_gasket_stretch * 100,
           "% and should stay between 1% and 5%"));
assert(hecate_hinge_bore_d > hecate_hinge_pin_d,
       "HECATE946 base hinge supports need positive pin clearance");
assert(hecate_hinge_clip_bore_d > hecate_hinge_pin_d,
       "HECATE946 snap clips need positive running clearance around the pin");
assert(hecate_hinge_clip_mouth < hecate_hinge_pin_d,
       "HECATE946 snap-clip mouth must be narrower than the metal pin");
assert(hecate_hinge_clip_mouth > hecate_hinge_pin_d * 0.65,
       "HECATE946 snap-clip mouth is too tight for a practical printed snap fit");

