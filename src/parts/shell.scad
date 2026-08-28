include <../lib/geometry.scad>
include <../lib/hardware.scad>

module base_hinge() {
    usable = case_w - 2 * hinge_edge_margin;
    outer_len = (usable - hinge_center_len - 2 * hinge_knuckle_gap) / 2;
    x_offset = (hinge_center_len + hinge_knuckle_gap + outer_len) / 2;
    for (x = [-x_offset, x_offset])
        translate([x, -case_d / 2 + hinge_outer_d / 2, base_h])
            hinge_barrel(outer_len, hinge_outer_d,
                         hinge_pin_d + hinge_pin_clearance);
}

module lid_hinge() {
    translate([0, -case_d / 2 + hinge_outer_d / 2, lid_h])
        hinge_barrel(hinge_center_len, hinge_outer_d,
                     hinge_pin_d + hinge_pin_clearance);
}

module base_hinge_relief() {
    translate([0, -case_d / 2 + hinge_outer_d / 2, base_h])
        rotate([0, 90, 0])
            cylinder(d = hinge_outer_d + 2 * printer_clearance,
                     h = hinge_center_len + 2 * hinge_knuckle_gap,
                     center = true);
}

module lid_hinge_relief() {
    usable = case_w - 2 * hinge_edge_margin;
    outer_len = (usable - hinge_center_len - 2 * hinge_knuckle_gap) / 2;
    x_offset = (hinge_center_len + hinge_knuckle_gap + outer_len) / 2;
    for (x = [-x_offset, x_offset])
        translate([x, -case_d / 2 + hinge_outer_d / 2, lid_h])
            rotate([0, 90, 0])
                cylinder(d = hinge_outer_d + 2 * printer_clearance,
                         h = outer_len + hinge_knuckle_gap,
                         center = true);
}

module latch_lugs(shell_h) {
    translate([0, case_d / 2 - latch_lug_depth / 2, shell_h - latch_lug_h])
        rounded_prism([latch_w, latch_lug_depth, latch_lug_h], 0.65);
}

module base_shell() {
    difference() {
        union() {
            translate([0, body_y, 0])
                rounded_cup(case_w, body_d, base_h, corner_r, wall, floor_t);
            base_hinge();
            latch_lugs(base_h);
            // The narrow compression tongue sits inboard of the shell wall.
            translate([0, body_y, base_h])
                rounded_ring(case_w - 2 * seal_inset,
                             body_d - 2 * seal_inset,
                             max(corner_r - seal_inset, 1.0),
                             seal_tongue_w,
                             seal_tongue_h);
        }
        base_hinge_relief();
        // Small underside relief reduces elephant-foot interference.
        translate([0, body_y, -epsilon])
            rounded_ring(case_w - elephant_foot_relief,
                         body_d - elephant_foot_relief,
                         corner_r,
                         elephant_foot_relief,
                         elephant_foot_relief + epsilon);
    }
}

module lid_shell() {
    difference() {
        union() {
            translate([0, body_y, 0])
                rounded_cup(case_w, body_d, lid_h, corner_r, wall, floor_t);
            lid_hinge();
            latch_lugs(lid_h);
        }
        lid_hinge_relief();
        // Gasket groove opens at the rim in print orientation.
        translate([0, body_y, lid_h - gasket_groove_d])
            rounded_ring(case_w - 2 * seal_inset,
                         body_d - 2 * seal_inset,
                         max(corner_r - seal_inset, 1.0),
                         gasket_groove_w,
                         gasket_groove_d + epsilon);
        translate([0, body_y, -epsilon])
            rounded_ring(case_w - elephant_foot_relief,
                         body_d - elephant_foot_relief,
                         corner_r,
                         elephant_foot_relief,
                         elephant_foot_relief + epsilon);
    }
}
