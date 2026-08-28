/*
  Central configuration.

  VERIFIED PUBLIC BEHN VALUES
  - Premium 20 exterior body: 1.50 x 4.00 x 4.00 in
  - PLA construction, gasket-sealed, perforated/railed trays
  - two magnetically attached 10-reed trays, 72% Boveda per tray

  All other dimensions below are original engineering starting values.
*/

assert(preset == "behn_premium20" || preset == "size60_studio",
       str("Unknown preset: ", preset));

inch = 25.4;
$fn = $preview ? 48 : 96;
epsilon = 0.02;

is_size60 = preset == "size60_studio";

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
tray_core_h = boveda_h + 0.60;
tray_guide_h = 4.20;
tray_guide_t = 1.10;
tray_outer_guide_t = 1.60;
// Each finished passage is 14.5 mm clear: 0.5 mm wider than the configured
// maximum Bb clarinet reed. Guide centers are derived from this dimension.
reed_slot_clear_w = 14.50;
tray_guide_span = 2 * (reed_slot_clear_w +
                       (tray_outer_guide_t + tray_guide_t) / 2) +
                  max(reeds_per_face - 2, 0) *
                       (reed_slot_clear_w + tray_guide_t);
tray_side_wall_w = (tray_w - tray_guide_span) / 2;
tray_stack_gap = 0.25;
// Physical Behn tray reference: 22 small apertures per column. The photograph
// has no absolute scale, so 1.6 mm is the fitted starting diameter.
tray_air_hole_d = 1.60;
tray_air_rows = 22;
tray_air_columns = 3;
tray_air_column_pitch = 4.30;
tray_air_edge_relief = 0.18;   // radial softening at the reed-facing edge
tray_air_edge_relief_h = 0.30; // printable micro-chamfer depth
tray_air_edge_steps = 3;
tray_reed_plane_edge_margin = 1.25;
// Blind side-loading slot: the pack enters from the raised reed-tip-frame end
// (+Y), travels only its own depth plus 1 mm, then contacts narrow support
// ribs aligned beneath the reed-guide walls.
tray_pack_slot_depth = boveda_d + boveda_slide_clearance;
tray_pack_stop_y = tray_d / 2 - tray_pack_slot_depth;
tray_pack_seated_y = tray_d / 2 - boveda_slide_clearance - boveda_d / 2;
tray_pack_vent_clearance = 0.25;
tray_pack_support_w = 1.60;
tray_pack_mouth_round_r = 2.0;

// Bb/Eb clarinet reed design envelope. Measure your own reeds before finalizing.
reed_length = 72.0;
reed_max_w = 14.0;
reed_max_h = 3.25;
reed_end_margin = 6.0;
reed_tip_clearance = 0.50;
rail_h = 0.55;
rail_w = 2.00;
rail_count = 2;
rail_rows = 11; // rails cover the lower 11 of the 22 aperture rows
elastic_band_positions = [-0.02]; // single aligned notch shown in Fig. 4
elastic_band_notch_w = 2.2;
elastic_band_notch_d = 1.6;

// Physical tray reference: compact magnets live in dedicated corner ears,
// fully outside the clear reed passages.
tray_corner_tab_d = 7.5;
tray_magnet_d = 4.0;
tray_magnet_h = 1.5;
magnet_d_clearance = 0.20;
magnet_h_clearance = 0.15;
magnet_lane_clearance = 0.25;
tray_magnet_x = (tray_w - tray_corner_tab_d) / 2;
tray_magnet_y = tray_d / 2 - tray_corner_tab_d / 2;
tray_core_side_wall_min = 1.50;
tray_body_w = max(tray_w - tray_corner_tab_d,
                  boveda_w + 2 * boveda_clearance +
                  2 * tray_core_side_wall_min);
tray_body_corner_r = min(
    tray_corner_r,
    max((tray_body_w - (boveda_w + 2 * boveda_clearance)) / 2 -
        tray_pack_mouth_round_r - 0.25,
        0.50)
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
assert(reed_slot_clear_w >= reed_max_w + 0.4,
       "Reed passages need at least 0.4 mm total width clearance");
assert(tray_side_wall_w > tray_outer_guide_t,
       "Configured reed passages do not fit within the tray width");
assert(tray_body_w <= tray_w,
       "Humidity channel and minimum side walls exceed the tray width");
assert(rail_rows > 0 && rail_rows <= tray_air_rows / 2,
       "Rail coverage must not extend beyond half of the aperture rows");
assert(abs(tray_magnet_x) + tray_corner_tab_d / 2 <= tray_w / 2,
       "Tray corner tab exceeds the tray width");
assert(abs(tray_magnet_y) + tray_corner_tab_d / 2 <= tray_d / 2,
       "Tray corner tab exceeds the tray depth");
assert((tray_magnet_d + magnet_d_clearance) / 2 + 1.0 <=
       tray_corner_tab_d / 2,
       "Magnet pocket leaves less than 1 mm around the corner tab");
assert(tray_magnet_x - (tray_magnet_d + magnet_d_clearance) / 2 >=
       tray_guide_span / 2 + tray_outer_guide_t / 2 +
       magnet_lane_clearance,
       "Magnet pocket intrudes into a reed passage");
assert(tray_d >= reed_length + 2 * reed_end_margin,
       "Tray is too short for the configured reed envelope");
assert(tray_w >= boveda_w + 2 * (tray_outer_guide_t + boveda_clearance),
       "Humidity pack is too wide for the tray recess");
assert(tray_pack_stop_y > -tray_d / 2 + tray_pack_support_w,
       "Humidity-pack stop ribs need positive length");

tray_total_h = tray_core_h + 2 * (tray_face_t + tray_guide_h);
loaded_stack_h = tray_count * tray_total_h
               + (tray_count - 1) * tray_stack_gap;
case_internal_h = case_h - 2 * floor_t;
assert(loaded_stack_h <= case_internal_h,
       str("Two loaded patent trays are ", loaded_stack_h - case_internal_h,
           " mm too tall for the closed case"));
