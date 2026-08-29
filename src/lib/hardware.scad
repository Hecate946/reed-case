include <geometry.scad>

module hinge_barrel(length, outer_d, hole_d) {
    difference() {
        rotate([0, 90, 0]) cylinder(d = outer_d, h = length, center = true);
        rotate([0, 90, 0]) cylinder(d = hole_d, h = length + 2 * epsilon, center = true);
    }
}

module magnet_pocket(d = tray_magnet_d, h = tray_magnet_h) {
    // Straight 4.20 x 2.15 mm pocket for nominal D4x2 hardware, plus a very
    // small lead-in at the mouth. The chamfer helps a real magnet/steel disc
    // start square without making the functional bore loose.
    pocket_d = d + magnet_d_clearance;
    pocket_h = h + magnet_h_clearance + epsilon;
    c = min(magnet_entry_chamfer, pocket_h / 3);

    union() {
        cylinder(d = pocket_d, h = pocket_h);
        if (c > 0)
            translate([0, 0, pocket_h - c - epsilon])
                cylinder(d1 = pocket_d,
                         d2 = pocket_d + 2 * c,
                         h = c + 2 * epsilon);
    }
}
