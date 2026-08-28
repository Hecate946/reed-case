include <../lib/geometry.scad>
include <../lib/hardware.scad>

function lane_x(i) = -tray_w / 2 + (i + 0.5) * tray_w / reeds_per_plate;

module plate_air_holes() {
    usable_y = min(reed_length - 2 * reed_end_margin, tray_d - 16);
    rows = floor(usable_y / tray_air_hole_pitch);
    for (i = [0 : reeds_per_plate - 1], j = [0 : rows])
        translate([lane_x(i),
                   -usable_y / 2 + j * usable_y / max(rows, 1),
                   -epsilon])
            cylinder(d = tray_air_hole_d, h = tray_t + 2 * epsilon);
}

module plate_magnet_bosses() {
    for (x = [-1, 1], y = [-1, 1])
        translate([x * tray_magnet_x,
                   y * tray_magnet_y, 0])
            cylinder(d = tray_magnet_d + 3.0, h = tray_boss_h);
}

module plate_magnet_pockets() {
    for (x = [-1, 1], y = [-1, 1])
        for (z = [-epsilon,
                  tray_boss_h - tray_magnet_h - magnet_h_clearance])
            translate([x * tray_magnet_x,
                       y * tray_magnet_y,
                       z])
                magnet_pocket();
}

module reed_support_rails() {
    lane_pitch = tray_w / reeds_per_plate;
    for (i = [0 : reeds_per_plate - 1], p = rail_positions)
        translate([lane_x(i), p * reed_length, tray_t])
            cube([min(reed_max_w - 1.0, lane_pitch - 2.0),
                  rail_w,
                  rail_h], center = true);
}

module retainer_anchor_slots() {
    y = -min(reed_length / 2 - 5, tray_d / 2 - 10);
    for (x = [-tray_w / 2 + 5, tray_w / 2 - 5])
        translate([x, y, tray_t / 2])
            cube([2.2 + printer_clearance, retainer_w + printer_clearance,
                  tray_t + 2 * epsilon], center = true);
}

module reed_plate() {
    difference() {
        union() {
            rounded_prism([tray_w, tray_d, tray_t], tray_corner_r);
            plate_magnet_bosses();
            reed_support_rails();
        }
        plate_air_holes();
        plate_magnet_pockets();
        retainer_anchor_slots();
    }
}

module retainer_strip() {
    lane_pitch = tray_w / reeds_per_plate;
    y_anchor = -min(reed_length / 2 - 5, tray_d / 2 - 10);
    union() {
        // Crossbar.
        cube([tray_w - 8, retainer_w, retainer_t], center = true);
        // Two downward locating tabs.
        for (x = [-tray_w / 2 + 5, tray_w / 2 - 5])
            translate([x, 0, -tray_t / 2])
                cube([2.0, retainer_w - printer_clearance,
                      tray_t + retainer_t], center = true);
        // Flexible fingers apply gentle heel pressure.
        for (i = [0 : reeds_per_plate - 1])
            translate([lane_x(i), retainer_w / 2 + 4.5, 0])
                linear_extrude(height = retainer_t)
                    hull() {
                        translate([0, -4.5]) circle(d = retainer_finger_w);
                        translate([0,  4.5]) circle(d = retainer_finger_w * 0.70);
                    }
    }
}
