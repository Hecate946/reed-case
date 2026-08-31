/*
  Dual side-latch spring supports and metal cover.

  Each side latch uses the same pair of compact supports. The supports are
  fused into the printed base, provide pilot holes for two M2 cover screws,
  and clamp the ends of a thin bowed 301 full-hard stainless spring strip.
  A separate 0.030 in / 0.76 mm stainless cover plate hides the complete
  spring cavity from the user while leaving the moving latch free behind it.
*/

include <../lib/geometry.scad>

module leaf_spring_mount_block() {
    w = leaf_spring_mount_width;
    d = leaf_spring_mount_depth;
    h = leaf_spring_mount_height;

    difference() {
        translate([-w/2, -d/2, 0]) cube([w, d, h]);

        // Pilot runs from the inboard cover face toward the case wall.
        translate([0,
                   -d/2 - epsilon,
                   side_latch_cover_screw_z])
            rotate([-90, 0, 0])
                cylinder(d = side_latch_mount_pilot_d,
                         h = d + 2 * epsilon,
                         $fn = is_fast_mesh ? 16 : 32);
    }
}

module left_leaf_spring_mount()  { leaf_spring_mount_block(); }
module right_leaf_spring_mount() { leaf_spring_mount_block(); }

module local_leaf_spring_mount_pair() {
    for (x = leaf_spring_mount_centers_x)
        translate([x, leaf_spring_mount_y, v2_base_floor_t])
            leaf_spring_mount_block();
}

module side_latch_local_transform(side = 1) {
    assert(side == -1 || side == 1);
    translate([0, side_latch_center_y, 0])
        rotate([0, 0, side > 0 ? -90 : 90])
            children();
}

module installed_leaf_spring_mounts() {
    for (side = [-1, 1])
        side_latch_local_transform(side)
            local_leaf_spring_mount_pair();
}

module side_latch_cover_plate_2d() {
    difference() {
        offset(r = 1.0)
            square([side_latch_cover_length - 2.0,
                    side_latch_cover_h - 2.0], center = true);

        for (x = leaf_spring_mount_centers_x)
            translate([x,
                       v2_base_floor_t + side_latch_cover_screw_z -
                       (side_latch_cover_bottom_z + side_latch_cover_h/2)])
                circle(d = side_latch_cover_screw_d,
                       $fn = is_fast_mesh ? 20 : 40);
    }
}

module side_latch_cover_plate() {
    // Natural export orientation: flat XY sheet, thickness +Z.
    linear_extrude(height = side_latch_cover_t)
        side_latch_cover_plate_2d();
}

module installed_side_latch_cover(side = 1) {
    // Cover is vertical in the assembled case, just inboard of the spring.
    side_latch_local_transform(side)
        translate([0,
                   side_latch_cover_center_y,
                   side_latch_cover_bottom_z + side_latch_cover_h/2])
            rotate([90, 0, 0])
                linear_extrude(height = side_latch_cover_t, center = true)
                    side_latch_cover_plate_2d();
}


module side_leaf_spring_strip_2d() {
    difference() {
        square([side_leaf_spring_length,
                side_leaf_spring_h], center = true);
        for (x = leaf_spring_mount_centers_x)
            translate([x, 0])
                circle(d = side_leaf_spring_screw_d,
                       $fn = is_fast_mesh ? 20 : 40);
    }
}

module side_leaf_spring_strip() {
    linear_extrude(height = side_leaf_spring_t)
        side_leaf_spring_strip_2d();
}

module local_leaf_spring_preview() {
    // A preview-only shallow bow between the two cover screws. The real part
    // is 0.006 in 301 full-hard stainless and is manually pre-bowed at install.
    steps = 12;
    span = leaf_spring_mount_centers_x[1] - leaf_spring_mount_centers_x[0];
    z0 = v2_base_floor_t +
         (side_latch_cover_screw_z - side_leaf_spring_h/2);

    for (i = [0 : steps - 1]) {
        x0 = leaf_spring_mount_centers_x[0] + span * i / steps;
        x1 = leaf_spring_mount_centers_x[0] + span * (i + 1) / steps;
        xm = (x0 + x1) / 2;
        // Zero bow at screws, maximum outward bow at center.
        y0 = side_latch_cover_outer_y +
             side_leaf_spring_prebow * sin(180 * i / steps);
        y1 = side_latch_cover_outer_y +
             side_leaf_spring_prebow * sin(180 * (i + 1) / steps);
        ym = (y0 + y1) / 2;
        seg = sqrt((x1-x0)*(x1-x0) + (y1-y0)*(y1-y0));
        ang = atan2(y1-y0, x1-x0);

        translate([xm, ym, z0])
            rotate([0, 0, ang])
                cube([seg + 0.15,
                      side_leaf_spring_t,
                      side_leaf_spring_h], center = true);
    }
}

module installed_leaf_spring_previews() {
    for (side = [-1, 1])
        side_latch_local_transform(side)
            local_leaf_spring_preview();
}

module installed_side_latch_covers() {
    for (side = [-1, 1])
        installed_side_latch_cover(side);
}
