include <geometry.scad>

module hinge_barrel(length, outer_d, hole_d) {
    difference() {
        rotate([0, 90, 0]) cylinder(d = outer_d, h = length, center = true);
        rotate([0, 90, 0]) cylinder(d = hole_d, h = length + 2 * epsilon, center = true);
    }
}

module magnet_pocket(d = tray_magnet_d, h = tray_magnet_h) {
    cylinder(d = d + magnet_d_clearance, h = h + magnet_h_clearance + epsilon);
}
