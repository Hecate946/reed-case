/*
  Alise CA100S-4P / CA100-4P 40 mm double-roller catch.

  Fit-critical geometry follows the seller's dimension drawing. Decorative
  details are intentionally simplified: this file is a mounting/clearance
  model, not a reverse-engineered manufacturing model.

  Option-C shell architecture:
  - compact rectangular main shell fits tightly around the cartridge
  - only the latch gets a centered outward blister
  - the O-ring remains continuous and is shifted slightly inward in the rim
  - the blister is tightened to minimize front protrusion
*/

include <../lib/geometry.scad>

module roller_catch_rounded_rect_2d(w, d, r) {
    assert(w > 2 * r && d > 2 * r);
    offset(r = r)
        square([w - 2 * r, d - 2 * r], center = true);
}

module roller_catch_local_housing_2d() {
    // Two rounded pads are hulled together to create the compact tapered
    // shoulders in the Option-C reference. The rear pad overlaps the normal
    // shell wall; the narrower front pad wraps the 40 mm catch closely.
    main_front_y = v2_case_d / 2;
    back_center_y = main_front_y;
    front_center_y = roller_catch_housing_front_y -
                     roller_catch_housing_front_d / 2;

    hull() {
        translate([roller_catch_center_x, back_center_y])
            roller_catch_rounded_rect_2d(roller_catch_housing_back_w,
                                         roller_catch_housing_back_d,
                                         roller_catch_housing_back_r);
        translate([roller_catch_center_x, front_center_y])
            roller_catch_rounded_rect_2d(roller_catch_housing_front_w,
                                         roller_catch_housing_front_d,
                                         roller_catch_housing_front_r);
    }
}

module roller_catch_local_housing(shell_h) {
    linear_extrude(height = shell_h, convexity = 10)
        roller_catch_local_housing_2d();
}

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

    for (sx = [-1, 1])
        translate([sx * roller_center_x,
                   -alise_catch_main_w / 2,
                   plate_t + roller_r])
            rotate([-90, 0, 0])
                cylinder(d = roller_d,
                         h = alise_catch_main_w,
                         $fn = is_fast_mesh ? 32 : 64);

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

module roller_catch_separation_scoops(seam_z) {
    // Lid-only half-ellipsoids at the seam. Their x positions are outside the
    // 22.4 mm cleared striker plate but still inside the local housing.
    if (roller_catch_grip_enable)
        for (sx = [-1, 1])
            translate([sx * roller_catch_grip_x,
                       roller_catch_grip_y,
                       seam_z])
                scale([1, roller_catch_grip_depth_scale, 1])
                    sphere(r = roller_catch_grip_r,
                           $fn = is_fast_mesh ? 28 : 56);
}

module roller_catch_base_boss() {
    // Solid local blister. It is fused to the normal front wall but does not
    // enlarge the interior cavity, so the tray can remain tight to the shell.
    roller_catch_local_housing(v2_base_h);
}

module roller_catch_base_mount_cuts() {
    rear_skin = roller_catch_pocket_back_y - roller_catch_housing_back_y;
    front_skin = roller_catch_housing_front_y - roller_catch_pocket_front_y;
    side_skin = (roller_catch_housing_front_w -
                 (alise_catch_main_l + 2 * roller_catch_xy_clearance)) / 2;

    assert(abs(roller_catch_center_x) < 0.001,
           "Main roller catch must remain horizontally centered");
    assert(rear_skin >= 2.00,
           "Local housing needs at least 2.0 mm rear support behind catch");
    assert(front_skin >= 2.00,
           "Local housing needs at least 2.0 mm front support ahead of catch");
    assert(abs(rear_skin - front_skin) < 0.01,
           "Front and rear latch support must stay symmetric");
    assert(side_skin >= 5.00,
           "Local housing needs at least 5 mm material beside catch plate");

    // Full-depth top-loading well sized directly from the published 40 x 9 mm
    // plate. The well is entirely outside the O-ring sealing cavity.
    translate([roller_catch_center_x,
               roller_catch_center_y,
               roller_catch_main_base_z])
        linear_extrude(height = roller_catch_well_h)
            alise_main_plate_2d(roller_catch_xy_clearance);

    translate([roller_catch_center_x,
               roller_catch_center_y,
               v2_base_h - roller_catch_well_leadin])
        linear_extrude(height = roller_catch_well_leadin + epsilon)
            alise_main_plate_2d(roller_catch_xy_clearance + 0.20);

    for (sx = [-1, 1])
        translate([roller_catch_center_x + sx * alise_catch_main_hole_pitch / 2,
                   roller_catch_center_y,
                   roller_catch_main_base_z - roller_catch_mount_pilot_depth])
            cylinder(d = roller_catch_mount_pilot_d,
                     h = roller_catch_mount_pilot_depth + epsilon,
                     $fn = is_fast_mesh ? 20 : 40);

}

module roller_catch_lid_boss() {
    // Matching exterior blister on the lid. The O-ring groove is cut through
    // the compact main rim in case.scad after this union. The rearward-shifted
    // latch remains outside the groove with a dedicated solid sealing bridge.
    roller_catch_local_housing(v2_lid_h);
}

module roller_catch_lid_mount_cuts() {
    striker_back_y = roller_catch_center_y -
                     (alise_catch_strike_w + 2 * roller_catch_xy_clearance) / 2;
    assert(striker_back_y - roller_catch_gasket_outer_y >= 1.00,
           "Striker pocket leaves less than 1 mm bridge to the O-ring groove");

    translate([roller_catch_center_x,
               roller_catch_center_y,
               roller_catch_strike_base_z])
        linear_extrude(height = roller_catch_strike_seat_depth + epsilon)
            alise_strike_plate_2d(roller_catch_xy_clearance);

    for (sx = [-1, 1])
        translate([roller_catch_center_x + sx * alise_catch_strike_hole_pitch / 2,
                   roller_catch_center_y,
                   roller_catch_strike_base_z - roller_catch_strike_pilot_depth])
            cylinder(d = roller_catch_strike_pilot_d,
                     h = roller_catch_strike_pilot_depth +
                         alise_catch_strike_plate_t_preview + epsilon,
                     $fn = is_fast_mesh ? 20 : 40);

    // In lid print orientation this removes the lower half of each ellipsoid
    // from the seam edge. Once mirrored closed, each becomes a small under-lid
    // thumbnail pocket while the base remains fully solid.
    roller_catch_separation_scoops(v2_lid_h);
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
