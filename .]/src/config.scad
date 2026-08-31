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
// latch/hinge logic stay intentionally stable.
v2_case_w = 190.00;
v2_case_d = 99.00;
v2_case_h = 31.50;
v2_base_h = 16.25;
v2_lid_h = v2_case_h - v2_base_h;
v2_corner_r = 9.00;
v2_wall = 3.40;
v2_base_floor_t = 3.80;
v2_lid_roof_t = 3.00;

// One centered cartridge-registration well. Magnets retain the cartridge;
// the shallow well only locates it in X/Y and prevents lateral sliding.
v2_tray_xy_clearance = 0.35;
v2_tray_recess_depth = 0.60;
v2_tray_recess_w = tray_body_w_open() + 2 * v2_tray_xy_clearance;
v2_tray_recess_d = tray_d_open() + 2 * v2_tray_xy_clearance;
v2_tray_recess_r = tray_body_corner_r_open() + v2_tray_xy_clearance;
v2_tray_x = 0;
// Keep the cartridge slightly hinge-ward to preserve the front latch/service
// strip. With the shorter new cartridge this also leaves comfortable clearance
// behind the tip-protection edge.
v2_tray_y = -4.50;
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
v2_humidity_bay_y = v2_tray_y;
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
// DUAL SIDE LATCHES + LEAF-SPRING ENCLOSURES
// ---------------------------------------------------------------------------
// The original front-latch kinematics are preserved exactly: each moving
// plate is biased outward, the lid wall cams the same rounded ramp inward,
// the catch snaps into a plain lid groove, and pressing the exterior button
// retracts the catch. The complete mechanism is simply made narrower and
// rotated onto each side wall. Both side buttons are independent and must be
// pressed together to release the lid.
side_latch_center_y = 4.00;
side_latch_count = 2;

// Local coordinates for one latch use +Y as "outward". After installation
// this local axis is rotated to +/-X at the two side walls.
latch_floor_pocket_depth = 1.00;
latch_floor_z = v2_base_floor_t - latch_floor_pocket_depth;
latch_pocket_side_clearance = 0.25;
latch_pocket_back_relief = 0.20;

// Slim but stiff moving plate. Local width becomes front-to-back span when the
// piece is rotated onto a side wall; depth is the amount consumed across the
// narrow cartridge-to-wall service strip.
latch_body_width = 28.00;
latch_body_depth = 2.40;
latch_body_bottom_z = latch_floor_z;
latch_body_height = v2_base_h - latch_body_bottom_z;

// Same 2.60 mm release travel as the proven front mechanism.
latch_inward_travel = 2.60;
latch_rest_wall_clearance = 0.10;
latch_wall_inner_y = v2_case_w / 2 - v2_wall;
latch_body_y = latch_wall_inner_y - latch_rest_wall_clearance -
               latch_body_depth / 2;

latch_pocket_width = latch_body_width + 2 * latch_pocket_side_clearance;
latch_pocket_front_y = latch_wall_inner_y;
latch_pocket_back_y = latch_body_y - latch_body_depth / 2 -
                      latch_inward_travel - latch_pocket_back_relief;
latch_pocket_depth_y = latch_pocket_front_y - latch_pocket_back_y;
latch_pocket_center_y = (latch_pocket_front_y + latch_pocket_back_y) / 2;

// Low-profile side button. It still finishes exactly flush with the case wall
// at full press, just as the front button did.
latch_button_width = 22.00;
latch_button_corner_radius = 2.20;
latch_button_center_x = 0;
latch_button_center_z = v2_base_h / 2;
latch_button_height = 2 * (latch_button_center_z - latch_floor_z);
latch_button_bottom_z = latch_button_center_z - latch_button_height / 2;
latch_button_bottom_offset = latch_button_bottom_z - latch_body_bottom_z;
latch_button_exposure = latch_inward_travel;
latch_button_pressed_exposure = latch_button_exposure - latch_inward_travel;
latch_feature_overlap = 0.15;
latch_button_depth =
    v2_case_w / 2 + latch_button_exposure -
    (latch_body_y + latch_body_depth / 2 - latch_feature_overlap);
latch_button_face_fraction =
    (latch_button_width * latch_button_height) /
    (v2_case_d * v2_base_h);

// Two rigid support blocks flank each side latch in the local X direction.
// Their inboard faces also locate the metal mechanism cover and clamp the ends
// of the bowed spring strip. This keeps the whole mechanism inside the narrow
// side margin instead of occupying cartridge space.
leaf_spring_mount_centers_x = [-18.00, 18.00];
leaf_spring_mount_width = 5.00;
leaf_spring_mount_depth = 5.20;
leaf_spring_mount_height = v2_base_h - v2_base_floor_t;
leaf_spring_mount_inner_gap =
    leaf_spring_mount_centers_x[1] - leaf_spring_mount_centers_x[0] -
    leaf_spring_mount_width;
latch_mount_side_gap =
    (leaf_spring_mount_inner_gap - latch_body_width) / 2;
leaf_spring_mount_y = latch_wall_inner_y - leaf_spring_mount_depth / 2;

// M2 cover fasteners. 1.60 mm printed pilot holes are intentionally sized for
// M2 thread-forming screws in a prototype; drill/tap or use inserts later if
// the final polymer/process benefits from them.
side_latch_cover_screw_d = 2.30;
side_latch_mount_pilot_d = 1.60;
side_latch_cover_screw_z = leaf_spring_mount_height * 0.56;
side_latch_cover_t = 0.76; // SendCutSend 0.030 in 304 stainless
side_latch_cover_h = leaf_spring_mount_height - 0.80;
side_latch_cover_bottom_z = v2_base_floor_t + 0.40;
side_latch_cover_length =
    leaf_spring_mount_centers_x[1] - leaf_spring_mount_centers_x[0] +
    leaf_spring_mount_width;
side_latch_cover_outer_y = latch_wall_inner_y - leaf_spring_mount_depth;
side_latch_cover_center_y = side_latch_cover_outer_y - side_latch_cover_t / 2;

// Bowed leaf spring clamped under the same two cover screws. Target material:
// 301 full-hard stainless shim stock, 0.006 in / 0.152 mm. The strip is
// installed with a shallow outward pre-bow; pressing the button flattens it,
// creating the return force without needing a coil spring or deep cavity.
side_leaf_spring_t = 0.1524;
side_leaf_spring_h = 7.00;
side_leaf_spring_length =
    leaf_spring_mount_centers_x[1] - leaf_spring_mount_centers_x[0] + 4.00;
side_leaf_spring_prebow =
    (latch_body_y - latch_body_depth / 2) - side_latch_cover_outer_y;
side_leaf_spring_screw_d = side_latch_cover_screw_d;

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
latch_catch_width = 13.50;
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

// 2 mm silicone O-ring prototype seal. The shallower 99 mm case uses a
// 170 mm ID ring so the same perimeter gland remains at about 1-3% stretch.
// Groove width intentionally leaves more gland volume than
// the V1 groove while the 1.45 mm depth gives ~27.5% nominal axial squeeze.
v2_gasket_id = 170.0;
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
assert(v2_side_margin >= leaf_spring_mount_depth +
       side_latch_cover_t + 0.75,
       "Side service strip is too narrow for latch, spring, and metal cover");
assert(v2_base_floor_t - v2_tray_recess_depth -
       v2_floor_magnet_depth >= 1.00,
       "Magnet pockets leave less than 1 mm of base-floor skin");
assert(v2_tray_top_z + 1.00 <= v2_lid_inside_roof_z,
       "Lid does not clear the seated trays");
assert(v2_gasket_groove_w + v2_gasket_outer_land <= v2_wall,
       "Gasket groove does not fit inside the rim");
assert(v2_gasket_stretch >= 0.01 && v2_gasket_stretch <= 0.03,
       str("2x170 O-ring stretch is ", v2_gasket_stretch * 100,
           "% and should stay between 1% and 3%"));
assert(v2_hinge_bore_d > v2_hinge_pin_d,
       "Hinge needs positive pin clearance");
assert(v2_hinge_knuckles % 2 == 1,
       "Hinge should use an odd number of alternating knuckles");
assert(abs(leaf_spring_mount_height -
           (v2_base_h - v2_base_floor_t)) < 0.01,
       "Side spring supports must fill the available base height");
assert(abs(side_latch_center_y) + side_latch_cover_length / 2 <=
       v2_inner_d / 2 - 2.00,
       "Side latch assembly is too close to the front/back case walls");
assert(latch_body_width > 0 &&
       latch_body_width < leaf_spring_mount_inner_gap,
       "Side latch body must fit between its spring supports");
assert(latch_mount_side_gap >= 1.00,
       "Side latch needs at least 1 mm running space from each support");
assert(latch_floor_pocket_depth > 0 &&
       v2_base_floor_t - latch_floor_pocket_depth >= 1.00,
       "Latch slide pan leaves less than 1 mm of base-floor skin");
assert(latch_pocket_back_y >= v2_tray_recess_w / 2 + 0.75,
       "Side latch slide pan collides with the cartridge well");
assert(side_latch_cover_center_y - side_latch_cover_t / 2 >=
       v2_tray_recess_w / 2 + 0.75,
       "Metal side-latch cover collides with the cartridge well");
assert(side_leaf_spring_prebow > 0.20 &&
       side_leaf_spring_prebow < latch_inward_travel + 0.30,
       "Leaf spring pre-bow must nearly flatten at full button travel");
assert(side_leaf_spring_t >= 0.12 && side_leaf_spring_t <= 0.22,
       "Leaf spring thickness should stay in the 0.12-0.22 mm tuning range");
assert(abs(latch_body_bottom_z + latch_body_height - v2_base_h) < 0.01,
       "Latch plate should end at the base-case seam");
assert(latch_rest_wall_clearance >= 0 &&
       latch_rest_wall_clearance < 0.30,
       "Locked side latch must rest against the inner side wall");
assert(latch_button_width < latch_body_width,
       "Exterior latch button must be narrower than its body");
assert(latch_button_corner_radius > 0 &&
       2 * latch_button_corner_radius < latch_button_height &&
       2 * latch_button_corner_radius < latch_button_width,
       "Button corner radius must fit inside the button face");
assert(latch_button_bottom_z >= latch_floor_z - 0.01,
       "Exterior button must not drop below the latch slide pan");
assert(latch_button_bottom_z - latch_fit_clearance > 1.50,
       "Button opening leaves too little material under the side wall");
assert(latch_button_bottom_z + latch_button_height < v2_base_h - 0.50,
       "Exterior button opening is too close to the case seam");
assert(abs(latch_button_pressed_exposure) < 0.01,
       "Fully pressed button must finish flush with the case exterior");
assert(abs(latch_button_center_x) < 0.01 &&
       abs(latch_button_center_z - v2_base_h / 2) < 0.01,
       "Each side button must be centered on its moving latch and case height");
assert(latch_button_face_fraction >= 0.10,
       "Side button should remain broad enough to press comfortably");
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
