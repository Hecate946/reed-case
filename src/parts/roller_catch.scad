/*
  Alise CA100S-4P / CA100-4P 40 mm double-roller catch.

  Fit-critical geometry follows the seller's dimension drawing. Decorative
  details are intentionally simplified: this file is a mounting/clearance
  model, not a reverse-engineered manufacturing model.
*/

include <../lib/geometry.scad>

module alise_main_plate_2d(clearance = 0) {
    offset(r = 0.8)
        square([alise_catch_main_l + 2 * clearance - 1.6,
                alise_catch_main_w + 2 * clearance - 1.6], center = true);
}

module alise_strike_plate_2d(clearance = 0) {
    offset(r = 0.7)
        square([alise_catch_strike_l + 2 * clearance - 1.4,
                alise_catch_strike_w + 2 * clearance - 1.4], center = true);
}

module alise_main_catch_preview() {
    plate_t = alise_catch_main_plate_t_preview;
    roller_d = max(alise_catch_main_h - plate_t, 1.0);
    roller_r = roller_d / 2;
    roller_gap = max(alise_catch_body_span - 2 * roller_d, 0.8);
    roller_center_x = roller_gap / 2 + roller_r;

    difference() {
        linear_extrude(height = plate_t)
            alise_main_plate_2d();
        for (sx = [-1, 1])
            translate([sx * alise_catch_main_hole_pitch / 2, 0, -epsilon])
                cylinder(d = alise_catch_mount_hole_d,
                         h = plate_t + 2 * epsilon,
                         $fn = is_fast_mesh ? 20 : 40);
    }

    // Two roller barrels. Their combined span is bounded by the seller's
    // published 24 mm body dimension.
    for (sx = [-1, 1])
        translate([sx * roller_center_x,
                   -alise_catch_main_w / 2,
                   plate_t + roller_r])
            rotate([-90, 0, 0])
                cylinder(d = roller_d,
                         h = alise_catch_main_w,
                         $fn = is_fast_mesh ? 32 : 64);

    // Small center bridge/adjuster representation for visual recognition.
    translate([0, 0, plate_t + roller_d * 0.48])
        rounded_prism([4.8, alise_catch_main_w, roller_d * 0.52], 0.7);
}

module alise_strike_preview() {
    plate_t = alise_catch_strike_plate_t_preview;
    difference() {
        linear_extrude(height = plate_t)
            alise_strike_plate_2d();
        for (sx = [-1, 1])
            translate([sx * alise_catch_strike_hole_pitch / 2, 0, -epsilon])
                cylinder(d = alise_catch_mount_hole_d,
                         h = plate_t + 2 * epsilon,
                         $fn = is_fast_mesh ? 20 : 40);
    }

    translate([0, 0, plate_t])
        rounded_prism([alise_catch_strike_tongue_w_preview,
                       alise_catch_strike_tongue_d_preview,
                       alise_catch_strike_tongue_h],
                      0.7);
}

module roller_catch_base_boss() {
    // Local front-wall thickening, fully fused into the normal 4.2 mm shell.
    // The exterior remains the same uninterrupted case surface.
    translate([roller_catch_center_x,
               roller_catch_base_boss_center_y,
               v2_base_floor_t])
        rounded_prism([roller_catch_base_boss_w,
                       roller_catch_base_boss_d,
                       roller_catch_base_boss_h], 1.5);
}

module roller_catch_base_mount_cuts() {
    // Full-depth top-loading well sized directly from the published 40 x 9 mm
    // plate. The metal plate lands at the bottom; the roller barrels rise to
    // within 0.15 mm of the case seam.
    translate([roller_catch_center_x,
               roller_catch_center_y,
               roller_catch_main_base_z])
        linear_extrude(height = roller_catch_well_h)
            alise_main_plate_2d(roller_catch_xy_clearance);

    // Very shallow opening lead-in so the recess reads like an intentional
    // molded pocket and makes hardware insertion easier.
    translate([roller_catch_center_x,
               roller_catch_center_y,
               v2_base_h - roller_catch_well_leadin])
        linear_extrude(height = roller_catch_well_leadin + epsilon)
            alise_main_plate_2d(roller_catch_xy_clearance + 0.20);

    // Two pilots at the exact 30 mm seller-published center spacing.
    for (sx = [-1, 1])
        translate([roller_catch_center_x + sx * alise_catch_main_hole_pitch / 2,
                   roller_catch_center_y,
                   roller_catch_main_base_z - roller_catch_mount_pilot_depth])
            cylinder(d = roller_catch_mount_pilot_d,
                     h = roller_catch_mount_pilot_depth + epsilon,
                     $fn = is_fast_mesh ? 20 : 40);
}

module roller_catch_lid_boss() {
    // Local thickening of the lid rim. It does not alter the outside of the
    // lid; it only provides enough hidden material to recess the 22 x 8 plate.
    translate([roller_catch_center_x,
               roller_catch_lid_boss_center_y,
               v2_lid_h - roller_catch_lid_boss_h])
        rounded_prism([roller_catch_lid_boss_w,
                       roller_catch_lid_boss_d,
                       roller_catch_lid_boss_h], 1.3);
}

module roller_catch_lid_mount_cuts() {
    // Recess the exact 22 x 8 mm plate so its top face lands at the lid seam.
    // After assembly only the 5 mm striker tongue projects below the lid.
    translate([roller_catch_center_x,
               roller_catch_center_y,
               roller_catch_strike_base_z])
        linear_extrude(height = roller_catch_strike_seat_depth + epsilon)
            alise_strike_plate_2d(roller_catch_xy_clearance);

    // Exact 15 mm striker-hole pitch from the seller drawing.
    for (sx = [-1, 1])
        translate([roller_catch_center_x + sx * alise_catch_strike_hole_pitch / 2,
                   roller_catch_center_y,
                   roller_catch_strike_base_z - roller_catch_strike_pilot_depth])
            cylinder(d = roller_catch_strike_pilot_d,
                     h = roller_catch_strike_pilot_depth +
                         alise_catch_strike_plate_t_preview + epsilon,
                     $fn = is_fast_mesh ? 20 : 40);
}

module installed_alise_main_catch_preview() {
    translate([roller_catch_center_x,
               roller_catch_center_y,
               roller_catch_main_base_z])
        alise_main_catch_preview();
}

module installed_alise_strike_preview() {
    translate([roller_catch_center_x,
               roller_catch_center_y,
               roller_catch_strike_base_z])
        alise_strike_preview();
}
