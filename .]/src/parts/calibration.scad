/* Small hardware-fit coupon. Print this before a long enclosure print if the
   printer/material is unfamiliar. */

include <../lib/geometry.scad>
include <../lib/hardware.scad>

module fit_coupon() {
    plate_w = 72;
    plate_d = 24;
    plate_h = 4;
    bore_clearances = [0.15, 0.25, 0.35];

    difference() {
        rounded_prism([plate_w, plate_d, plate_h], 2.0);

        // Three vertical 2 mm pin gauges.
        for (i = [0 : len(bore_clearances) - 1])
            translate([-22 + i * 14, 0, -epsilon])
                cylinder(d = v2_hinge_pin_d + bore_clearances[i],
                         h = plate_h + 2 * epsilon,
                         $fn = is_fast_mesh ? 24 : 48);

        // One production-size D4x2 magnet pocket.
        translate([23, 0, plate_h - tray_magnet_h - magnet_h_clearance])
            magnet_pocket();
    }
}
