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

module shell_tray_magnet_towers() {
    tower_h = boveda_h + 0.20;
    for (x = [-1, 1], y = [-1, 1])
        translate([x * tray_magnet_x, y * tray_magnet_y, floor_t])
            cylinder(d = tray_magnet_d + 3.0, h = tower_h);
}

module shell_tray_magnet_pockets() {
    tower_h = boveda_h + 0.20;
    for (x = [-1, 1], y = [-1, 1])
        translate([x * tray_magnet_x,
                   y * tray_magnet_y,
                   floor_t + tower_h - tray_magnet_h - magnet_h_clearance])
            magnet_pocket();
}

module shell_pack_guides() {
    guide_h = 1.2;
    guide_t = 1.1;
    for (x = [-1, 1])
        translate([x * (boveda_w / 2 + boveda_clearance), 0, floor_t])
            cube([guide_t, boveda_d + 2 * boveda_clearance, guide_h], center = true);
    for (y = [-1, 1])
        translate([0, y * (boveda_d / 2 + boveda_clearance), floor_t])
            cube([boveda_w + 2 * boveda_clearance, guide_t, guide_h], center = true);
}
