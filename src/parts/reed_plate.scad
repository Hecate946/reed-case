/*
  Parametric implementation of the double-sided tray disclosed in
  US12103755B2, particularly Figs. 1-10 and claims 1-16.

  The patent does not disclose millimeter dimensions. The topology below
  follows the disclosure; dimensions are fitted to the configured reed and
  humidity-pack envelopes in config.scad.

  One complete tray = 2 x behn_tray_face + 1 x behn_tray_core.
*/

include <../lib/geometry.scad>
include <../lib/hardware.scad>

function guide_t(i) = i == 0 || i == reeds_per_face
                    ? tray_outer_guide_t
                    : tray_guide_t;
function guide_x(i) = i == 0
                    ? -tray_guide_span / 2
                    : i == reeds_per_face
                    ? tray_guide_span / 2
                    : -tray_guide_span / 2 +
                      reed_slot_clear_w +
                      (tray_outer_guide_t + tray_guide_t) / 2 +
                      (i - 1) * (reed_slot_clear_w + tray_guide_t);
function lane_x(i) = (guide_x(i) + guide_t(i) / 2 +
                      guide_x(i + 1) - guide_t(i + 1) / 2) / 2;
function aperture_column_pitch() = min(tray_air_column_pitch,
                                       reed_slot_clear_w / 3.7);
function aperture_start_y() = -min(reed_length / 2 - 3.0,
                                    tray_d / 2 - 5.0);
function aperture_end_y() = min(reed_length / 2 - 3.0,
                                 tray_d / 2 - 5.0);
function aperture_row_pitch() = (aperture_end_y() - aperture_start_y()) /
                                max(tray_air_rows - 1, 1);
function aperture_y(row) = aperture_start_y() + row * aperture_row_pitch();
function rail_start_y() = aperture_start_y() - aperture_row_pitch() / 2;
function rail_end_y() = (aperture_y(rail_rows - 1) +
                         aperture_y(rail_rows)) / 2;
function reed_plane_front_y() = aperture_start_y() -
                                 tray_air_hole_d / 2 -
                                 tray_air_edge_relief -
                                 tray_reed_plane_edge_margin;
function tip_stop_inner_y() = rail_start_y() + reed_length +
                              reed_tip_clearance;
function ventilation_field_half_w() =
    abs(lane_x(0)) +
    (tray_air_columns - 1) / 2 * aperture_column_pitch() +
    (tray_air_hole_d + 2 * tray_air_edge_relief) / 2 +
    tray_pack_vent_clearance;

module patent_face_outline_2d() {
    // The physical tray places each magnet in a compact external corner ear.
    union() {
        offset(r = tray_body_corner_r)
            square([tray_body_w - 2 * tray_body_corner_r,
                    tray_d - 2 * tray_body_corner_r], center = true);
        for (x = [-1, 1], y = [-1, 1])
            translate([x * tray_magnet_x, y * tray_magnet_y])
                circle(d = tray_corner_tab_d);
    }
}

module patent_platform(h) {
    linear_extrude(height = h) patent_face_outline_2d();
}

module patent_ventilation_apertures_2d(hole_d = tray_air_hole_d) {
    // Physical tray: 22 rows of three small apertures in each passage.
    for (i = [0 : reeds_per_face - 1],
         row = [0 : tray_air_rows - 1],
         col = [0 : tray_air_columns - 1]) {
        x_offset = (col - (tray_air_columns - 1) / 2) *
                   aperture_column_pitch();
        translate([lane_x(i) + x_offset, aperture_y(row)])
            circle(d = hole_d, $fn = $preview ? 20 : 40);
    }
}

module patent_front_plane_cutout_2d() {
    // Keep a measured solid margin beyond the final softened aperture while
    // leaving the rest of the insertion end open. The outer-frame strips and
    // corner ears remain full length for stiffness.
    left_inner_x = guide_x(0) + guide_t(0) / 2;
    right_inner_x = guide_x(reeds_per_face) -
                    guide_t(reeds_per_face) / 2;
    front_y = -tray_d / 2 - epsilon;
    back_y = reed_plane_front_y();

    assert(back_y > -tray_d / 2,
           "Reed-plane margin extends beyond the tray outline");

    translate([(left_inner_x + right_inner_x) / 2,
               (front_y + back_y) / 2])
        square([right_inner_x - left_inner_x,
                back_y - front_y], center = true);
}

module patent_perforated_layer(z, h, hole_d) {
    translate([0, 0, z])
        linear_extrude(height = h)
        difference() {
            patent_face_outline_2d();
            patent_ventilation_apertures_2d(hole_d);
            patent_front_plane_cutout_2d();
        }
}

module patent_perforated_platform() {
    // A three-layer micro-chamfer softens the reed-facing aperture rims. This
    // remains a small set of 2D extrusions, avoiding the enormous CSG tree
    // produced by hundreds of individual 3D fillets in OpenSCAD 2021.
    relief_step_h = tray_air_edge_relief_h / tray_air_edge_steps;
    core_h = tray_face_t - tray_air_edge_relief_h;

    union() {
        patent_perforated_layer(0, core_h + epsilon, tray_air_hole_d);
        for (step = [0 : tray_air_edge_steps - 1])
            patent_perforated_layer(
                core_h + step * relief_step_h - epsilon,
                relief_step_h + 2 * epsilon,
                tray_air_hole_d + 2 * tray_air_edge_relief *
                    (step + 1) / tray_air_edge_steps
            );
    }
}

module patent_guide_walls() {
    for (i = [0 : reeds_per_face]) {
        wall_t = guide_t(i);
        start_y = reed_plane_front_y();
        end_y = tip_stop_inner_y() + epsilon;

        // A plain rectangular divider is stronger, faster to render, and
        // exactly matches the front edge of the reed-facing sheet.
        translate([guide_x(i), (start_y + end_y) / 2,
                   tray_face_t + tray_guide_h / 2])
            cube([wall_t, end_y - start_y, tray_guide_h], center = true);
    }
}

module patent_longitudinal_stock_rails() {
    // The two rails sit midway between the three aperture columns. They begin
    // just below the first aperture and stop halfway between rows 11 and 12,
    // exactly covering the lower 11 rows of the 22-row pattern.
    end_radius = rail_w / 2;

    for (i = [0 : reeds_per_face - 1], side = [-1, 1])
        hull()
            for (y = [rail_start_y() + end_radius,
                      rail_end_y() - end_radius])
                translate([lane_x(i) +
                           side * aperture_column_pitch() / 2,
                           y,
                           tray_face_t])
                    scale([1, 1, rail_h / end_radius])
                        sphere(d = rail_w, $fn = $preview ? 16 : 32);
}

module patent_reed_tip_stop() {
    // Solid raised frame at the back end where the reed tip rests. Its inner
    // face is one reed length plus a small clearance beyond the rail entrance.
    inner_y = tip_stop_inner_y();
    outer_y = tray_d / 2;
    stop_d = outer_y - inner_y;

    translate([0, (inner_y + outer_y) / 2,
               tray_face_t + tray_guide_h / 2])
        cube([tray_guide_span + tray_outer_guide_t,
              stop_d,
              tray_guide_h], center = true);
}

module patent_outer_side_walls() {
    // Raised side frames start at the outside face of the outer guide walls.
    // The corner ears and their magnet pockets therefore stay completely out
    // of the two outer reed passages.
    outer_guide_face = tray_guide_span / 2 + tray_outer_guide_t / 2;
    tray_body_edge = tray_body_w / 2;
    side_frame_w = tray_body_edge - outer_guide_face;

    for (x = [-1, 1])
        translate([0, 0, tray_face_t])
            linear_extrude(height = tray_guide_h)
                union() {
                    hull()
                        for (y = [-1, 1])
                            translate([x * (outer_guide_face +
                                       side_frame_w / 2),
                                       y * (tray_d - side_frame_w) / 2])
                                circle(d = side_frame_w,
                                       $fn = $preview ? 24 : 48);
                    for (y = [-1, 1])
                        translate([x * tray_magnet_x,
                                   y * tray_magnet_y])
                            circle(d = tray_corner_tab_d);
                }
}

module patent_magnet_apertures() {
    for (x = [-1, 1], y = [-1, 1])
        translate([x * tray_magnet_x, y * tray_magnet_y,
                   tray_face_t + tray_guide_h -
                   tray_magnet_h - magnet_h_clearance])
            magnet_pocket();
}

module patent_band_notches() {
    // One continuous transverse cut produces aligned notches 140 in every
    // inner and outer guide wall.
    for (p = elastic_band_positions)
        translate([0, p * reed_length,
                   tray_face_t + tray_guide_h - elastic_band_notch_d / 2])
            cube([tray_w + 2 * epsilon,
                  elastic_band_notch_w,
                  elastic_band_notch_d + epsilon], center = true);
}

module patent_pack_stop_half_ribs() {
    // Each face carries half of every longitudinal stop support. The mirrored
    // face supplies the other half, so the assembled tray has full-height ribs
    // without a transverse connector or loose islands in the core print.
    rib_start_y = -tray_d / 2;
    rib_end_y = tray_pack_stop_y;
    rib_length = rib_end_y - rib_start_y;

    // Straight, constant-section stops aligned with the guide walls. Each
    // face supplies half the core height and the halves meet at mid-plane.
    for (i = [1 : reeds_per_face - 1])
        translate([guide_x(i), (rib_start_y + rib_end_y) / 2,
                   -tray_core_h / 4])
            cube([tray_pack_support_w, rib_length,
                  tray_core_h / 2 + epsilon], center = true);
}

module behn_tray_face() {
    union() {
        patent_perforated_platform();
        patent_pack_stop_half_ribs();
        difference() {
            union() {
            patent_guide_walls();
            patent_outer_side_walls();
            patent_longitudinal_stock_rails();
            patent_reed_tip_stop();
            }
            patent_band_notches();
            patent_magnet_apertures();
        }
    }
}

module behn_tray_core() {
    // The channel is wide enough to expose even the outer edges of the
    // chamfered ventilation holes, not merely wide enough for the pack.
    cavity_w = max(boveda_w + 2 * boveda_clearance,
                   2 * ventilation_field_half_w());
    mouth_round_r = min(tray_pack_mouth_round_r,
                        (tray_body_w - cavity_w) / 2 -
                        tray_body_corner_r - epsilon);

    assert(mouth_round_r >= 0.5,
           "Humidity channel leaves too little wall for a rounded mouth");

    difference() {
        patent_platform(tray_core_h);
        // The central channel is open at both ends. Circular reliefs at each
        // mouth round the exposed inner corners for easier insertion.
        translate([-cavity_w / 2,
                   -tray_d / 2 - epsilon,
                   -epsilon])
            cube([cavity_w,
                  tray_d + 2 * epsilon,
                  tray_core_h + 2 * epsilon]);
        for (x = [-1, 1], y = [-1, 1])
            translate([x * cavity_w / 2,
                       y * tray_d / 2,
                       -epsilon])
                // Clamp the fillet to preserve thin preset walls.
                cylinder(r = mouth_round_r,
                         h = tray_core_h + 2 * epsilon,
                         $fn = $preview ? 24 : 48);
    }
}

module behn_tray() {
    color([0.16, 0.18, 0.21]) behn_tray_core();
    color([0.20, 0.22, 0.25])
        translate([0, 0, tray_core_h]) behn_tray_face();
    color([0.20, 0.22, 0.25])
        mirror([0, 0, 1]) behn_tray_face();
}

// Backward-compatible alias for the original preview name.
module reed_plate() {
    behn_tray_face();
}
