/*
  Reed case configuration.

  Edit this file for dimensions and hardware. The model has one supported
  product architecture: the single 10-reed-per-face cartridge prototype.
  `mesh_profile` only changes
  tessellation/detail; it never changes functional dimensions.
*/

mesh_profile_default = "prototype";
active_mesh_profile = is_undef(mesh_profile) ? mesh_profile_default : mesh_profile;
assert(active_mesh_profile == "prototype" || active_mesh_profile == "fine",
       str("Unknown mesh_profile: ", active_mesh_profile));

is_fast_mesh = active_mesh_profile == "prototype";
$fn = is_fast_mesh ? 24 : ($preview ? 56 : 96);
epsilon = 0.02;

// ---------------------------------------------------------------------------
// REED TRAY
// ---------------------------------------------------------------------------

// The retained Behn reference stays at its original five reeds per face.
reeds_per_face = 5;

// New H946 open-air cartridge capacity.
tray_reeds_per_face = 10;

// Boveda Size 8 design envelope. Measure the exact packs you plan to use
// before freezing production dimensions.
boveda_w = 69.85;
boveda_d = 63.50;
boveda_h = 4.50;
boveda_clearance = 1.00;
boveda_slide_clearance = 1.00;
boveda_thickness_clearance = 0.60;

// Boveda Size 60 scale-reference envelope. Boveda publishes the planar size
// as 3.5 x 5.25 in (88.90 x 133.35 mm). Filled thickness varies with moisture
// content, so 6 mm is an intentionally editable preview estimate only.
boveda_size_60_w = 133.35;
boveda_size_60_d = 88.90;
boveda_size_60_h_preview = 6.00;
boveda_size_60_corner_r_preview = 4.00;

// Vandoren Traditional Bb clarinet reed, strength 3.5 (CR1035), modeled
// from published/measured clarinet-reed geometry. Vandoren identifies CR1035
// as its Traditional Bb 3.5 reed but does not publish a full manufacturing
// drawing, so the dimensions below use the best documented physical envelope:
// 67.5 mm total length, 13.15 mm maximum/tip width, 34.1 mm vamp length,
// 2.8-3.25 mm heel thickness and 0.09-0.11 mm tip thickness.
// The 11.0 mm heel width follows standard French/Boehm reed finishing practice.
reed_length = 67.50;
reed_max_w = 13.15;
reed_heel_w = 11.00;
reed_vamp_length = 34.10;
reed_max_h = 3.05;
reed_tip_h = 0.10;
reed_tip_round_depth = 1.25;
reed_tip_clearance = 0.50;
reed_end_margin = 7.50;

// Reed passages and tray body.
reed_slot_clear_w = 14.30;
tray_guide_t = 1.10;
tray_guide_h = 4.20;
tray_face_t = 1.20;
tray_corner_r = 3.00;
tray_border_w_min = 6.40;
tray_d = 87.50;

tray_passage_field_w = reeds_per_face * reed_slot_clear_w +
                       (reeds_per_face - 1) * tray_guide_t;
tray_core_side_wall_min = 1.50;
tray_body_w = max(tray_passage_field_w + 2 * tray_border_w_min,
                  boveda_w + 2 * boveda_clearance +
                  2 * tray_core_side_wall_min);
tray_border_w = (tray_body_w - tray_passage_field_w) / 2;
tray_body_corner_r = min(tray_corner_r,
                         max(tray_border_w - 0.50, 0.50));
tray_w = tray_body_w; // full sweep width for band-groove cutters

tray_core_h = boveda_h + boveda_thickness_clearance;
tray_total_h = tray_core_h + 2 * (tray_face_t + tray_guide_h);

// Ventilation field.
tray_air_hole_d = 1.60;
tray_air_rows = 22;
tray_air_columns = 3;
tray_air_column_pitch = 4.30;
tray_air_edge_relief = 0.18;
tray_air_edge_relief_h = 0.30;
tray_air_edge_steps = 2;
tray_platform_top_chamfer = 0.20;
tray_wall_top_chamfer = 0.20;
tray_feature_fuse_overlap = 0.10;
tray_reed_plane_edge_margin = 1.25;
tray_pack_vent_clearance = 0.25;

// Reed support rails.
rail_h = 0.55;
rail_w = 2.00;
rail_rows = 11;
stock_rails_enable = true;

// Reference-tray details.
lane_numbers_enable = true;
lane_number_size = 2.60;
lane_number_depth = 0.50;
lane_number_margin = 0.80;
lane_number_font = "Liberation Sans:style=Bold";
front_plane_cutout_enable = false;
guide_walls_full_length = true;
aperture_heel_margin = 2.00;
aperture_tip_margin = 1.20;
guide_end_taper = tray_guide_h;

// Round silicone cord used to retain reeds.
elastic_band_d = 2.00;
elastic_band_clearance = 0.25;
elastic_band_seat_depth = 0.35;
elastic_band_row_gaps = [8.5, 11.5];

// Humidity-pack channel.
tray_pack_slot_depth = boveda_d + boveda_slide_clearance;
tray_pack_stop_y = tray_d / 2 - tray_pack_slot_depth;
tray_pack_seated_y = tray_d / 2 - boveda_slide_clearance - boveda_d / 2;
tray_pack_support_w = 1.60;
tray_core_heel_bridge_d = 2.00;

// Tray retention hardware. Four identical pockets exist on each tray face so
// a tray can be flipped. Prototype recommendation: magnets in the case base,
// mild-steel discs in both tray faces.
tray_magnet_d = 4.00;
tray_magnet_h = 2.00;
magnet_d_clearance = 0.20;
magnet_h_clearance = 0.15;
magnet_entry_chamfer = 0.15;
magnet_lane_clearance = 0.25;
magnet_wall_min = 1.00;
tray_magnet_edge_inset = 12.00;
tray_magnet_y = tray_d / 2 - tray_magnet_edge_inset;
tray_magnet_x = (tray_body_w - tray_border_w) / 2;

// ---------------------------------------------------------------------------
// CASE
// ---------------------------------------------------------------------------

// Compact enclosure for one full-width H946 10-reed-per-face cartridge.
// An integrated humidity bay now lives under the cartridge, so the case is
// slightly taller than the earlier no-Boveda variant. Width/depth and the
// hinge and seal logic stay intentionally stable.
v2_case_w = 190.00;
v2_case_d = 107.00;
v2_case_h = 31.50;
v2_base_h = 16.25;
v2_lid_h = v2_case_h - v2_base_h;
v2_corner_r = 9.00;
v2_wall = 4.20;
v2_base_floor_t = 4.20;
v2_lid_roof_t = 3.40;

// One centered cartridge-registration well. Magnets retain the cartridge;
// the shallow well only locates it in X/Y and prevents lateral sliding.
v2_tray_xy_clearance = 0.35;
v2_tray_recess_depth = 0.60;
v2_tray_recess_w = tray_body_w_open() + 2 * v2_tray_xy_clearance;
v2_tray_recess_d = tray_d_open() + 2 * v2_tray_xy_clearance;
v2_tray_recess_r = tray_body_corner_r_open() + v2_tray_xy_clearance;
v2_tray_x = 0;
// Keep the cartridge exactly centered in the enclosure. The compact front
// purchased roller catch now lives entirely in the symmetric front service margin.
v2_tray_y = 0;
v2_inner_w = v2_case_w - 2 * v2_wall;
v2_inner_d = v2_case_d - 2 * v2_wall;
v2_side_margin = (v2_inner_w - v2_tray_recess_w) / 2;
v2_front_margin = v2_inner_d / 2 -
                  (v2_tray_y + v2_tray_recess_d / 2);
v2_back_margin = v2_inner_d / 2 +
                 v2_tray_y - v2_tray_recess_d / 2;

// Four D4x2 magnets under the single cartridge. The base floor is deliberately
// thick enough to leave >1 mm of material below these pockets.
v2_floor_magnet_depth = tray_magnet_h + magnet_h_clearance;


// ---------------------------------------------------------------------------
// INTEGRATED HUMIDITY BAY + VENTED DROP-IN LID (2 x Boveda Size 8)
// ---------------------------------------------------------------------------
// Instead of a full removable cassette, the case now uses a shallow humidity
// bay built directly into the base floor. Two Size 8 packs sit in divided
// wells and a thin removable perforated lid simply rests on a surrounding
// ledge above them.
v2_humidity_bay_corner_r = 3.00;
v2_humidity_bay_pack_clearance = 0.80;
v2_humidity_bay_divider_t = 2.40;
v2_humidity_bay_pocket_w =
    boveda_w + 2 * v2_humidity_bay_pack_clearance;
v2_humidity_bay_pocket_d =
    boveda_d + 2 * v2_humidity_bay_pack_clearance;
v2_humidity_bay_inner_w =
    2 * v2_humidity_bay_pocket_w + v2_humidity_bay_divider_t;
v2_humidity_bay_inner_d = v2_humidity_bay_pocket_d;
v2_humidity_bay_opening_w = v2_humidity_bay_inner_w + 5.10;
v2_humidity_bay_opening_d = v2_humidity_bay_inner_d + 5.10;
v2_humidity_bay_x = 0;
v2_humidity_bay_y = 0;
v2_humidity_bay_floor_z = v2_base_floor_t;
v2_humidity_bay_depth = 6.60;
v2_humidity_bay_top_z = v2_humidity_bay_floor_z + v2_humidity_bay_depth;

// Tray-support frame around the bay. The reed cartridge lands on this frame,
// leaving the center open for the humidity bay cover.
v2_tray_bottom_z = v2_humidity_bay_top_z + 0.20;
v2_tray_support_h = v2_tray_bottom_z - v2_base_floor_t;
v2_tray_support_outer_w = v2_tray_recess_w;
v2_tray_support_outer_d = v2_tray_recess_d;
v2_tray_support_outer_r = v2_tray_recess_r;
v2_tray_support_inner_w = v2_humidity_bay_opening_w;
v2_tray_support_inner_d = v2_humidity_bay_opening_d;
v2_tray_support_inner_r = v2_humidity_bay_corner_r;

// Removable vented cover.
v2_humidity_cover_t = 1.80;
v2_humidity_cover_clearance = 0.22;
v2_humidity_cover_seat_w = 1.30;
v2_humidity_cover_seat_depth = 0.95;
v2_humidity_cover_w = v2_tray_support_inner_w - 2 * v2_humidity_cover_clearance;
v2_humidity_cover_d = v2_tray_support_inner_d - 2 * v2_humidity_cover_clearance;
v2_humidity_cover_corner_r = max(v2_tray_support_inner_r - v2_humidity_cover_clearance, 0.8);
v2_humidity_cover_z = v2_tray_bottom_z - v2_humidity_cover_t;
v2_humidity_cover_finger_r = 7.00;
v2_humidity_cover_finger_inset = 0.10;

// Denser slot field than the first prototype.
v2_humidity_cover_slot_l = 12.80;
v2_humidity_cover_slot_w = 1.60;
v2_humidity_cover_slot_rows = 9;
v2_humidity_cover_slot_cols = 12;
v2_humidity_cover_slot_pitch_x = 11.80;
v2_humidity_cover_slot_pitch_y = 6.00;

// No cover magnets for now: the lid simply sits on the ledge and lifts out
// by the semicircular finger notch. Keep these zeroed placeholders so the
// geometry can evolve later without breaking old references.
v2_humidity_cover_magnet_d = 0;
v2_humidity_cover_magnet_h = 0;
v2_humidity_cover_magnet_edge_inset_x = 0;
v2_humidity_cover_magnet_edge_inset_y = 0;
v2_humidity_cover_magnet_x = 0;
v2_humidity_cover_magnet_y = 0;
// Conventional alternating-knuckle hinge around a replaceable 2 mm metal pin.
v2_hinge_pin_d = 2.00;
v2_hinge_bore_d = 2.30;
v2_hinge_outer_d = 6.00;
v2_hinge_wall_gap = 0.25;
v2_hinge_root_overlap = 0.55;
v2_hinge_root_h = 2.20;
v2_hinge_edge_margin = 11.00;
v2_hinge_knuckles = 9;
v2_hinge_gap = 0.70;
v2_hinge_usable = v2_case_w - 2 * v2_hinge_edge_margin;
v2_hinge_knuckle_len = (v2_hinge_usable -
                         (v2_hinge_knuckles - 1) * v2_hinge_gap) /
                        v2_hinge_knuckles;
v2_hinge_y = -v2_case_d / 2 - v2_hinge_outer_d / 2 -
              v2_hinge_wall_gap;
v2_hinge_pin_len = v2_hinge_usable + 2.00;

// ---------------------------------------------------------------------------
// ALISE CA100S-4P 40 mm DOUBLE-ROLLER CATCH
// ---------------------------------------------------------------------------
// Purchased hardware: Amazon ASIN B0D8L6GJWK, Alise model CA100S-4P,
// manufacturer part CA100-4P, 40 mm silver version.
//
// Seller-published dimensional drawing:
//   main mounting plate: 40 x 9 mm
//   main mounting-hole pitch: 30 mm
//   roller/body span: 24 mm
//   overall catch height: 10 mm
//   mounting-hole diameter: 4 mm
//   striker plate: 22 x 8 mm
//   striker mounting-hole pitch: 15 mm
//   striker tongue rise: 5 mm
//
// The seller does not publish plate thickness or every radius. Those values
// below are preview-only assumptions and do NOT control the printed mounting
// locations. The printed case uses the published plate envelopes, pitches, and
// overall heights, with small adjustable clearances.
alise_catch_main_l = 40.00;
alise_catch_main_w = 9.00;
alise_catch_main_h = 10.00;
alise_catch_body_span = 24.00;
alise_catch_main_hole_pitch = 30.00;
alise_catch_mount_hole_d = 4.00;
alise_catch_strike_l = 22.00;
alise_catch_strike_w = 8.00;
alise_catch_strike_hole_pitch = 15.00;
alise_catch_strike_tongue_h = 5.00;

// Preview-only metal thicknesses; measure the delivered parts before freezing
// a production revision. They are deliberately isolated from fit-critical
// dimensions.
alise_catch_main_plate_t_preview = 1.20;
alise_catch_strike_plate_t_preview = 1.20;
alise_catch_strike_tongue_w_preview = 5.00;
alise_catch_strike_tongue_d_preview = 6.00;
alise_catch_preview_edge_r = 0.55;

// Centered front installation. The 40 x 9 catch is now buried directly into
// a locally thickened center section of the front wall rather than sitting on
// a visible pedestal. The enclosure remains symmetric: case depth is increased
// equally front/back so the centered tray and humidity bay do not move.
roller_catch_center_x = 0;
roller_catch_outer_skin = 3.00;
roller_catch_inner_skin = 0.80;
roller_catch_top_gap = 0.15;
roller_catch_xy_clearance = 0.20;
roller_catch_center_y = v2_case_d / 2 - roller_catch_outer_skin -
                        alise_catch_main_w / 2;
roller_catch_main_base_z = v2_base_h - alise_catch_main_h -
                           roller_catch_top_gap;

// Integrated front-wall housing. 12.8 mm total local thickness leaves a
// robust 3 mm exterior skin, the full 9 mm hardware width, and a small inner
// web while still clearing the centered cartridge by roughly 0.35 mm.
roller_catch_front_wall_t = roller_catch_outer_skin +
                            alise_catch_main_w +
                            roller_catch_inner_skin;
roller_catch_front_wall_inner_y = v2_case_d / 2 - roller_catch_front_wall_t;
roller_catch_base_boss_w = alise_catch_main_l + 4.00;
roller_catch_base_boss_d = roller_catch_front_wall_t;
roller_catch_base_boss_center_y = v2_case_d / 2 -
                                  roller_catch_front_wall_t / 2;
roller_catch_base_boss_h = v2_base_h - v2_base_floor_t;

// The well opens from the seam down to the catch plate. Its plan envelope is
// only 0.20 mm larger per side than the seller's exact 40 x 9 mm plate, making
// the hardware look molded into the frame. Countersunk mounting screws remain
// accessible at the bottom of the well.
roller_catch_well_h = v2_base_h - roller_catch_main_base_z + epsilon;
roller_catch_mount_pilot_d = 2.50;
roller_catch_mount_pilot_depth = 3.00;
roller_catch_well_leadin = 0.35;

// The 22 x 8 striker is embedded separately into a local lid-rim thickening.
// Its metal plate ends flush with the seam; only the published 5 mm tongue
// projects down into the rollers after the lid is closed.
roller_catch_lid_outer_skin = v2_case_d / 2 -
                              (roller_catch_center_y + alise_catch_strike_w/2);
roller_catch_lid_inner_skin = 0.80;
roller_catch_lid_wall_t = roller_catch_lid_outer_skin +
                          alise_catch_strike_w +
                          roller_catch_lid_inner_skin;
roller_catch_lid_boss_w = alise_catch_strike_l + 4.00;
roller_catch_lid_boss_d = roller_catch_lid_wall_t;
roller_catch_lid_boss_center_y = v2_case_d / 2 - roller_catch_lid_wall_t / 2;
roller_catch_strike_pilot_d = 2.50;
roller_catch_strike_pilot_depth = 2.50;
roller_catch_lid_boss_h = alise_catch_strike_plate_t_preview +
                          roller_catch_strike_pilot_depth + 0.80;
roller_catch_strike_seat_depth = alise_catch_strike_plate_t_preview + 0.05;
roller_catch_strike_base_z = v2_lid_h - alise_catch_strike_plate_t_preview;

// 2 mm silicone O-ring prototype seal. The centered 107 mm-deep case uses a
// 175 mm ID ring so the same perimeter gland remains at about 1-3% stretch.
// Groove width intentionally leaves more gland volume than
// the V1 groove while the 1.45 mm depth gives ~27.5% nominal axial squeeze.
v2_gasket_id = 175.0;
v2_gasket_d = 2.00;
v2_gasket_groove_w = 2.60;
v2_gasket_groove_d = 1.45;
v2_gasket_outer_land = 0.50;
v2_gasket_path_w = v2_case_w - 2 * v2_gasket_outer_land -
                   v2_gasket_groove_w;
v2_gasket_path_d = v2_case_d - 2 * v2_gasket_outer_land -
                   v2_gasket_groove_w;
v2_gasket_path_r = v2_corner_r - v2_gasket_outer_land -
                   v2_gasket_groove_w / 2;
v2_gasket_path_len =
    2 * (v2_gasket_path_w + v2_gasket_path_d -
         4 * v2_gasket_path_r) +
    2 * PI * v2_gasket_path_r;
v2_gasket_free_center_len = PI * (v2_gasket_id + v2_gasket_d);
v2_gasket_stretch = v2_gasket_path_len / v2_gasket_free_center_len - 1;

// Lid mark. Keep this shallow for a cheap FDM appearance prototype. It is
// placed by its bottom-right corner as seen looking down at the closed case
// with the roller catch facing you.
v2_engraving_enable = true;
v2_brand_text = "ASASI";
v2_brand_size = 7.00;
v2_brand_depth = 0.40;
v2_brand_font = "Liberation Sans:style=Bold";
v2_brand_margin_x = 15.00;
v2_brand_margin_y = 11.00;


// Preview-only exploded/open spacing.
exploded_gap = 18;
v2_open_angle = 105;

// Derived cartridge placement in the base. tray() is centered around Z=0.
// The new tray-support frame carries the cartridge above the humidity bay,
// so the cartridge now sits on the raised frame rather than in a floor recess.
v2_tray_bottom_offset = tray_face_t_open() + tray_guide_h -
                        tray_face_join_overlap_open() / 2;
v2_tray_seated_z = v2_tray_bottom_z + v2_tray_bottom_offset;
v2_tray_top_z = v2_tray_bottom_z + tray_total_h_open();
v2_lid_inside_roof_z = v2_case_h - v2_lid_roof_t;

// ---------------------------------------------------------------------------
// SAFETY / FEASIBILITY CHECKS
// ---------------------------------------------------------------------------

assert(reed_slot_clear_w >= reed_max_w + 0.40,
       "Reed passages need at least 0.4 mm total width clearance");
assert(tray_border_w >= tray_border_w_min - 0.01,
       "Tray side borders are too narrow");
assert(tray_d >= reed_length + reed_tip_clearance + tray_border_w +
                 reed_end_margin,
       "Tray is too short for the configured reed envelope");
assert(tray_guide_h >= rail_h + reed_max_h,
       "Guide walls must protect the reed thickness envelope");
assert(tray_magnet_x - (tray_magnet_d + magnet_d_clearance) / 2 >=
       tray_passage_field_w / 2 + magnet_lane_clearance,
       "Tray hardware pocket intrudes into a reed passage");
assert((tray_magnet_d + magnet_d_clearance) / 2 + magnet_wall_min <=
       tray_border_w / 2,
       "Tray hardware pocket leaves too little side-border material");
assert(tray_core_heel_bridge_d > 0 &&
       tray_core_heel_bridge_d <= aperture_heel_margin + 0.01,
       "Core heel bridge must stay behind the first ventilation row");
assert(tray_body_w_open() <= v2_inner_w - 2 * v2_tray_xy_clearance,
       "Open cartridge is wider than the case interior");
assert(tray_d_open() <= v2_inner_d - 2 * v2_tray_xy_clearance,
       "Open cartridge is deeper than the case interior");
assert(tray_magnet_x_open() +
       (tray_magnet_d + magnet_d_clearance) / 2 <= tray_body_w_open() / 2,
       "Open-cartridge magnet pocket extends beyond the side frame");
assert(v2_side_margin >= 0.75,
       "Case is too narrow for the cartridge well");
assert(boveda_size_60_w <= v2_inner_w &&
       boveda_size_60_d <= v2_inner_d,
       "Centered Boveda Size 60 preview does not fit inside the base");
assert(boveda_size_60_h_preview <= v2_base_h - v2_base_floor_t,
       "Boveda Size 60 preview is taller than the base interior");
assert(v2_back_margin >= 0.75,
       "Case leaves too little clearance behind the cartridge well");
assert(v2_humidity_bay_opening_w <= v2_tray_support_outer_w - 8.00,
       "Humidity bay opening is too wide for the tray support frame");
assert(v2_humidity_bay_opening_d <= v2_tray_support_outer_d - 8.00,
       "Humidity bay opening is too deep for the tray support frame");
assert(v2_humidity_bay_depth < v2_tray_bottom_z - v2_base_floor_t + 0.01,
       "Humidity bay depth does not fit below the raised cartridge");
assert(v2_tray_support_inner_w < v2_tray_support_outer_w - 4.00,
       "Tray support frame side rails are too thin");
assert(v2_tray_support_inner_d < v2_tray_support_outer_d - 4.00,
       "Tray support frame front/back rails are too thin");
assert(v2_base_floor_t - v2_tray_recess_depth -
       v2_floor_magnet_depth >= 1.00,
       "Magnet pockets leave less than 1 mm of base-floor skin");
assert(v2_tray_top_z + 1.00 <= v2_lid_inside_roof_z,
       "Lid does not clear the seated trays");
assert(v2_gasket_groove_w + v2_gasket_outer_land <= v2_wall,
       "Gasket groove does not fit inside the rim");
assert(v2_gasket_stretch >= 0.01 && v2_gasket_stretch <= 0.03,
       str("2x175 O-ring stretch is ", v2_gasket_stretch * 100,
           "% and should stay between 1% and 3%"));
assert(v2_hinge_bore_d > v2_hinge_pin_d,
       "Hinge needs positive pin clearance");
assert(v2_hinge_knuckles % 2 == 1,
       "Hinge should use an odd number of alternating knuckles");
assert(roller_catch_base_boss_h > 2.00,
       "Integrated roller-catch wall housing is too shallow");
assert(roller_catch_front_wall_inner_y >= v2_tray_recess_d / 2 + 0.25,
       "Integrated roller-catch wall housing collides with the centered tray");
assert(v2_case_d / 2 -
       (roller_catch_center_y +
        (alise_catch_main_w + 2*roller_catch_xy_clearance)/2) >= 2.50,
       "Roller-catch well leaves less than 2.5 mm exterior skin");
assert((roller_catch_center_y -
        (alise_catch_main_w + 2*roller_catch_xy_clearance)/2) -
       roller_catch_front_wall_inner_y >= 0.50,
       "Roller-catch well leaves too little inner wall web");
assert(roller_catch_main_base_z + alise_catch_main_h <=
       v2_base_h - 0.10,
       "Alise rollers should finish just below the base seam");
assert(roller_catch_lid_boss_h >
       alise_catch_strike_plate_t_preview + roller_catch_strike_pilot_depth,
       "Striker rim thickening is too shallow for its plate and pilot holes");
assert(alise_catch_main_hole_pitch < alise_catch_main_l,
       "Main catch mounting-hole pitch must fit its plate");
assert(alise_catch_strike_hole_pitch < alise_catch_strike_l,
       "Striker mounting-hole pitch must fit its plate");
assert(roller_catch_mount_pilot_depth < roller_catch_main_base_z - 0.80,
       "Main catch pilot holes leave too little bottom skin");
assert(roller_catch_strike_pilot_depth < roller_catch_lid_boss_h,
       "Striker pilot holes are too deep for the lid rim thickening");
assert(roller_catch_center_y +
       (alise_catch_strike_w + 2*roller_catch_xy_clearance)/2 <=
       v2_case_d/2 - v2_gasket_outer_land - v2_gasket_groove_w - 0.10,
       "Embedded striker pocket reaches the gasket groove");
