/*
  Reed case configuration.

  Edit this file for dimensions and hardware. The model has one supported
  product architecture: the two-tray prototype. `mesh_profile` only changes
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

reeds_per_face = 5;

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

// Compact two-tray enclosure. The former hygrometer bay is intentionally
// removed; the future humidity reader should not dictate the shell yet.
v2_case_w = 190.00;
v2_case_d = 107.00;
v2_case_h = 24.50;
v2_base_h = v2_case_h / 2;
v2_lid_h = v2_case_h - v2_base_h;
v2_corner_r = 9.00;
v2_wall = 3.40;
v2_base_floor_t = 3.80;
v2_lid_roof_t = 3.00;

// Tray registration. Magnets retain the trays; the wells only locate them.
v2_tray_xy_clearance = 0.35;
v2_tray_recess_depth = 0.60;
v2_tray_recess_w = tray_body_w + 2 * v2_tray_xy_clearance;
v2_tray_recess_d = tray_d + 2 * v2_tray_xy_clearance;
v2_tray_recess_r = tray_body_corner_r + v2_tray_xy_clearance;
v2_between_trays = 2.60;
v2_tray_x = (v2_tray_recess_w + v2_between_trays) / 2;
// Shift both trays toward the hinge to create the front service strip shown in
// the latch sketch. The spring itself is real hardware and is not modeled.
v2_tray_y = -4.50;
v2_inner_w = v2_case_w - 2 * v2_wall;
v2_inner_d = v2_case_d - 2 * v2_wall;
v2_side_margin = (v2_inner_w - 2 * v2_tray_recess_w -
                  v2_between_trays) / 2;
v2_front_margin = v2_inner_d / 2 -
                  (v2_tray_y + v2_tray_recess_d / 2);
v2_back_margin = v2_inner_d / 2 +
                 v2_tray_y - v2_tray_recess_d / 2;

// Four D4x2 magnets under each tray. The base floor is deliberately thick
// enough to leave >1 mm of material below these pockets.
v2_floor_magnet_depth = tray_magnet_h + magnet_h_clearance;

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
// FULL-HEIGHT SPRING-SUPPORT BLOCKS
// ---------------------------------------------------------------------------
// Each side is one plain rectangular solid from the base floor to the case
// seam. The left and right blocks remain separate modules for easy tweaking.
leaf_spring_mount_centers_x = [-42.00, 42.00];
leaf_spring_mount_width = 13.00;
leaf_spring_mount_depth = 8.50;
leaf_spring_mount_height = v2_base_h - v2_base_floor_t;
// Top-view step proportions: the back two-thirds stays full width; the front
// third keeps only the outward half. Change these two values to tune the shape.
leaf_spring_mount_front_step_depth = leaf_spring_mount_depth / 3;
leaf_spring_mount_outer_foot_width = leaf_spring_mount_width / 2;
leaf_spring_mount_wall_overlap = 0.60;
leaf_spring_mount_y = v2_case_d / 2 - v2_wall -
                      leaf_spring_mount_depth / 2 +
                      leaf_spring_mount_wall_overlap;

// ---------------------------------------------------------------------------
// MOVING FRONT LATCH PIECE
// ---------------------------------------------------------------------------
// The body is centered between the closest full-width faces of the two spring
// mounts. Its width is intentionally much smaller than that gap so the moving
// piece has generous space on both sides. It is never fused into case_base.
leaf_spring_mount_inner_gap =
    leaf_spring_mount_centers_x[1] - leaf_spring_mount_centers_x[0] -
    leaf_spring_mount_width;
// The base floor carries a shallow recessed slide pan under the moving latch.
// The pan walls guide the plate in X, and dropping the plate into the pan is
// what lets the exterior button grow tall enough to look centered on the front
// face. There are no separate guide rails or stop tabs anywhere in the design.
latch_floor_pocket_depth = 1.00;
latch_floor_z = v2_base_floor_t - latch_floor_pocket_depth;
latch_pocket_side_clearance = 0.30;
latch_pocket_back_relief = 0.30;

latch_body_width = 56.00;
latch_mount_side_gap =
    (leaf_spring_mount_inner_gap - latch_body_width) / 2;
latch_body_depth = 4.00;
latch_body_bottom_z = latch_floor_z;
// The plate fills the interior height and ends exactly at the base seam. Only
// the closing tongue rises above the seam.
latch_body_height = v2_base_h - latch_body_bottom_z;

// The leaf spring biases the latch outward (+Y) until the plate's full-width
// front face lands on the inner front wall: that wall is the locked stop, so no
// stop tabs are needed. A closing lid or a finger on the button moves the
// complete latch inward (-Y) by this amount.
latch_inward_travel = 2.60;
latch_rest_wall_clearance = 0.10;
latch_wall_inner_y = v2_case_d / 2 - v2_wall;
latch_body_y = latch_wall_inner_y - latch_rest_wall_clearance -
               latch_body_depth / 2;

// Slide-pan footprint. The rear pan wall sits one small relief behind the fully
// pressed plate, so it only ever acts as an overtravel backstop.
latch_pocket_width = latch_body_width + 2 * latch_pocket_side_clearance;
latch_pocket_front_y = latch_wall_inner_y;
latch_pocket_back_y = latch_body_y - latch_body_depth / 2 -
                      latch_inward_travel - latch_pocket_back_relief;
latch_pocket_depth_y = latch_pocket_front_y - latch_pocket_back_y;
latch_pocket_center_y = (latch_pocket_front_y + latch_pocket_back_y) / 2;

// The front button is integral to the moving plate. Its bottom is flush with
// the plate bottom in the slide pan, which is what lets a vertically centered
// button reach this height on a base whose interior floor sits above the
// exterior mid-plane.
latch_button_width = 48.00;
latch_button_corner_radius = 2.60;
latch_button_center_x = 0;
latch_button_center_z = v2_base_h / 2;
latch_button_height = 2 * (latch_button_center_z - latch_floor_z);
latch_button_bottom_z = latch_button_center_z - latch_button_height / 2;
latch_button_bottom_offset = latch_button_bottom_z - latch_body_bottom_z;
latch_button_exposure = latch_inward_travel;
latch_button_pressed_exposure =
    latch_button_exposure - latch_inward_travel;
latch_feature_overlap = 0.15;
latch_button_depth =
    v2_case_d / 2 + latch_button_exposure -
    (latch_body_y + latch_body_depth / 2 - latch_feature_overlap);
latch_button_face_fraction =
    (latch_button_width * latch_button_height) /
    (v2_case_w * v2_base_h);

// ---------------------------------------------------------------------------
// CLOSING TONGUE AND CATCH
// ---------------------------------------------------------------------------
// One solid rises above the seam. Seen from the side its outward face reads as
// ---\ : a flat crown, then a single straight ramp falling outward to a
// protruding catch. The descending lid wall rides that ramp and drives the
// latch inward; when the lid groove lines up, the spring snaps the catch in.
//
// The catch underside is horizontal, so the seal load presses straight up into
// it and cannot back-drive the latch. Nothing else carries the lock.
// The tongue is set back from the plate's front face so the fillet under the
// catch stays inside the lid wall line. Without that setback the fillet, not
// the flat land, would be the first thing the lid groove touches.
latch_tongue_front_setback = 0.50;
latch_tongue_depth = latch_body_depth - latch_tongue_front_setback;
latch_catch_width = 22.00;
latch_catch_height = 6.60;
latch_catch_extension = 2.15;
latch_catch_underside_above_seam = 3.00;
latch_catch_crest_top_above_seam = 5.20;
latch_catch_ramp_start_inset = 0.60;
latch_catch_edge_round = 0.55;
latch_catch_notch_round = 0.35;
latch_catch_plan_corner_radius = 1.20;
// The profile continues this far below the seam so the rounded bottom corners
// are buried inside the plate instead of showing as a notch at the joint.
latch_catch_root_sink = 1.60;

latch_catch_front_y = latch_body_y + latch_body_depth / 2 -
                      latch_tongue_front_setback;
latch_catch_back_y = latch_body_y - latch_body_depth / 2;
latch_catch_fillet_outer_y = latch_catch_front_y +
                             latch_catch_notch_round;
latch_catch_crest_y = latch_catch_front_y + latch_catch_extension;
latch_catch_ramp_start_y = latch_catch_front_y -
                           latch_catch_ramp_start_inset;
latch_catch_crest_height =
    latch_catch_crest_top_above_seam - latch_catch_underside_above_seam;
// How far the button must move before the catch clears the lid wall.
latch_release_retraction = latch_catch_crest_y - latch_wall_inner_y;
// Height at which the closing ramp crosses the lid wall face. Everything the
// tongue occupies outboard of that wall lies below this line, so the lid groove
// roof only has to clear this one number.
latch_catch_ramp_wall_cross_z =
    latch_catch_crest_top_above_seam +
    (latch_catch_crest_y - latch_wall_inner_y) /
    (latch_catch_crest_y - latch_catch_ramp_start_y) *
    (latch_catch_height - latch_catch_crest_top_above_seam);

// FDM running clearance around the removable plate and the button stem.
latch_fit_clearance = 0.25;
// Used only by the CLI clearance checks: the locked catch underside and the
// groove floor are meant to touch, so collision sampling backs off this far.
latch_seat_check_relief = 0.02;

// The lid owns only a plain rounded pocket--no striker projects from it. Press
// the lid to the seam and the catch slips in with latch_lid_rest_lift of room
// top and bottom; release it and the seal lifts the lid by exactly that amount
// until the pocket floor lands on the flat catch underside.
v2_lid_latch_groove_width = latch_catch_width + 0.60;
v2_lid_latch_groove_depth = 1.80;
v2_lid_latch_groove_floor_above_seam = 2.80;
v2_lid_latch_groove_roof_above_seam =
    latch_catch_ramp_wall_cross_z + 0.25;
v2_lid_latch_groove_height =
    v2_lid_latch_groove_roof_above_seam -
    v2_lid_latch_groove_floor_above_seam;
v2_lid_latch_groove_corner_radius = 0.60;
v2_lid_latch_groove_inner_y = latch_wall_inner_y;
v2_lid_latch_groove_outer_y =
    v2_lid_latch_groove_inner_y + v2_lid_latch_groove_depth;
v2_lid_latch_groove_outer_skin =
    v2_wall - v2_lid_latch_groove_depth;

// Locked-state results.
latch_lid_rest_lift = latch_catch_underside_above_seam -
                      v2_lid_latch_groove_floor_above_seam;
latch_crest_roof_clearance =
    v2_lid_latch_groove_roof_above_seam -
    latch_catch_crest_top_above_seam;
latch_lid_engagement = latch_catch_crest_y - latch_wall_inner_y;

// 2 mm silicone O-ring prototype seal. A 175 mm ID ring follows this path at
// about 1-3% stretch. Groove width intentionally leaves more gland volume than
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
// with the button facing you.
v2_engraving_enable = true;
v2_brand_text = "ASASI";
v2_brand_size = 7.00;
v2_brand_depth = 0.40;
v2_brand_font = "Liberation Sans:style=Bold";
v2_brand_margin_x = 15.00;
v2_brand_margin_y = 11.00;

// Latch results that depend on the seal dimensions above.
latch_gasket_squeeze = (v2_gasket_d - v2_gasket_groove_d) -
                       latch_lid_rest_lift;
// Lid material left between the seal gland and the latch pocket floor.
latch_groove_seal_web = v2_lid_latch_groove_floor_above_seam -
                        v2_gasket_groove_d;

// Preview-only exploded/open spacing.
exploded_gap = 18;
v2_open_angle = 105;

// Derived tray placement in the base.
v2_tray_bottom_offset = tray_face_t + tray_guide_h;
v2_tray_seated_z = v2_base_floor_t - v2_tray_recess_depth +
                    v2_tray_bottom_offset;
v2_tray_top_z = v2_base_floor_t - v2_tray_recess_depth + tray_total_h;
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
assert(v2_side_margin >= 0.75,
       "Case is too narrow for the two tray wells");
assert(boveda_size_60_w <= v2_inner_w &&
       boveda_size_60_d <= v2_inner_d,
       "Centered Boveda Size 60 preview does not fit inside the base");
assert(boveda_size_60_h_preview <= v2_base_h - v2_base_floor_t,
       "Boveda Size 60 preview is taller than the base interior");
assert(v2_back_margin >= 0.75,
       "Case leaves too little clearance behind the tray wells");
assert(v2_front_margin >= leaf_spring_mount_depth + 1.50,
       "Front service strip is too shallow for the spring mounts");
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
assert(abs(leaf_spring_mount_height -
           (v2_base_h - v2_base_floor_t)) < 0.01,
       "Spring-support blocks must fill the available base height");
assert(leaf_spring_mount_front_step_depth > 0 &&
       leaf_spring_mount_front_step_depth < leaf_spring_mount_depth,
       "Spring-support front step depth must fit inside the block depth");
assert(leaf_spring_mount_outer_foot_width > 0 &&
       leaf_spring_mount_outer_foot_width < leaf_spring_mount_width,
       "Spring-support outer foot must be narrower than the full block");
assert(leaf_spring_mount_y - leaf_spring_mount_depth / 2 >=
       v2_tray_y + v2_tray_recess_d / 2 + 1.50,
       "Spring-support blocks collide with the tray wells");
assert(latch_body_width > 0 &&
       latch_body_width < leaf_spring_mount_inner_gap,
       "Latch body must fit between the spring mounts");
assert(latch_mount_side_gap >= 5.00,
       "Latch needs generous space from both spring mounts");
assert(latch_floor_pocket_depth > 0 &&
       v2_base_floor_t - latch_floor_pocket_depth >= 1.00,
       "Latch slide pan leaves less than 1 mm of base-floor skin");
assert(latch_pocket_back_y >
       v2_tray_y + v2_tray_recess_d / 2 + 1.00,
       "Latch slide pan collides with the tray wells");
assert(latch_pocket_width / 2 <
       leaf_spring_mount_centers_x[1] - leaf_spring_mount_width / 2,
       "Latch slide pan undercuts the spring-support blocks");
assert(abs(latch_body_bottom_z + latch_body_height - v2_base_h) < 0.01,
       "Latch plate should end at the base-case seam");
assert(latch_rest_wall_clearance >= 0 &&
       latch_rest_wall_clearance < 0.30,
       "Locked latch must rest against the inner front wall");
assert(latch_button_width < latch_body_width,
       "Exterior latch button must be narrower than its body");
assert(latch_button_corner_radius > 0 &&
       2 * latch_button_corner_radius < latch_button_height &&
       2 * latch_button_corner_radius < latch_button_width,
       "Button corner radius must fit inside the button face");
assert(latch_button_bottom_z >= latch_floor_z - 0.01,
       "Exterior button must not drop below the latch slide pan");
assert(latch_button_bottom_z - latch_fit_clearance > 1.50,
       "Button opening leaves too little material under the front wall");
assert(latch_button_bottom_z + latch_button_height < v2_base_h - 0.50,
       "Exterior button opening is too close to the case seam");
assert(abs(latch_button_pressed_exposure) < 0.01,
       "Fully pressed button must finish flush with the case exterior");
assert(abs(latch_button_center_x) < 0.01 &&
       abs(latch_button_center_z - v2_base_h / 2) < 0.01,
       "Latch button must be horizontally and vertically centered");
assert(latch_button_face_fraction >= 0.10,
       "Exterior button should cover at least 10% of the front face");
assert(latch_catch_width > 0 &&
       latch_catch_width < latch_body_width,
       "Closing tongue width must fit on the latch plate");
assert(latch_catch_extension > latch_rest_wall_clearance &&
       latch_release_retraction > 0,
       "Catch must actually reach past the lid wall face");
assert(latch_inward_travel > latch_release_retraction + 0.50,
       "Button travel must fully retract the catch from the lid groove");
assert(latch_catch_crest_height >= 1.80,
       "Catch crest is too shallow to hold the lid reliably");
assert(latch_catch_crest_top_above_seam < latch_catch_height &&
       latch_catch_underside_above_seam > v2_gasket_groove_d,
       "Catch must clear the seal gland and sit below the tongue crown");
assert(latch_catch_height < v2_lid_h - v2_lid_roof_t - 1.00,
       "Closing tongue is too tall for the lid interior");
assert(latch_catch_ramp_start_inset > 0 &&
       latch_catch_ramp_start_inset < latch_tongue_depth / 2,
       "Ramp must start inside the tongue front face");
assert(latch_catch_edge_round > 0 &&
       2 * latch_catch_edge_round < latch_catch_crest_height,
       "Catch edge rounding must fit on the crest face");
assert(latch_catch_plan_corner_radius > 0 &&
       2 * latch_catch_plan_corner_radius < latch_catch_width,
       "Tongue plan radius must fit inside its width");
assert(latch_tongue_front_setback > 0 &&
       latch_tongue_front_setback < latch_body_depth / 2,
       "Tongue setback must fit inside the latch plate");
assert(latch_catch_fillet_outer_y <= latch_wall_inner_y - 0.15,
       "Fillet under the catch must stay inside the lid wall line");
assert(latch_catch_root_sink > 0 &&
       latch_catch_root_sink > latch_catch_edge_round,
       "Tongue profile must sink far enough into the plate");
assert(v2_lid_latch_groove_width > latch_catch_width &&
       v2_lid_latch_groove_depth > latch_lid_engagement,
       "Lid groove needs positive clearance around the catch");
assert(latch_lid_rest_lift > 0.10 && latch_lid_rest_lift < 0.35,
       str("Lid rest lift is ", latch_lid_rest_lift,
           " mm and should stay between 0.10 and 0.35 mm"));
assert(latch_crest_roof_clearance > 0,
       "Lid groove roof must clear the closing ramp at the wall face");
assert(latch_gasket_squeeze >= 0.25 && latch_gasket_squeeze <= 0.45,
       str("Locked O-ring squeeze is ", latch_gasket_squeeze,
           " mm and should stay between 0.25 and 0.45 mm"));
assert(latch_groove_seal_web >= 1.00,
       str("Only ", latch_groove_seal_web,
           " mm of lid material separates the seal gland from the latch pocket"));
assert(v2_lid_latch_groove_outer_skin >= 1.20,
       "Lid latch groove must leave a robust outer wall skin");
assert(v2_lid_latch_groove_roof_above_seam <
       v2_lid_h - v2_lid_roof_t - 1.50,
       "Lid latch groove leaves too little wall above it");
