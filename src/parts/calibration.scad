include <../lib/geometry.scad>
include <../lib/hardware.scad>

module gasket_coupon() {
    coupon_w = 44;
    coupon_d = 22;
    plate_h = 3;
    separation = coupon_w + 8;

    // Male coupon.
    translate([-separation / 2, 0, 0]) {
        rounded_prism([coupon_w, coupon_d, plate_h], 2);
        translate([0, 0, plate_h])
            rounded_ring(coupon_w - 8, coupon_d - 8, 3,
                         seal_tongue_w, seal_tongue_h);
    }

    // Female coupon. Lift, rotate, and clamp over the male coupon for testing.
    translate([separation / 2, 0, 0])
        difference() {
            rounded_prism([coupon_w, coupon_d, plate_h], 2);
            translate([0, 0, plate_h - gasket_groove_d])
                rounded_ring(coupon_w - 8, coupon_d - 8, 3,
                             gasket_groove_w, gasket_groove_d + epsilon);
        }
    }

module tolerance_coupon() {
    clearances = [0.10, 0.20, 0.30, 0.40];
    coupon_w = 60;
    coupon_d = 25;
    coupon_h = 4;
    difference() {
        rounded_prism([coupon_w, coupon_d, coupon_h], 2);
        for (i = [0 : len(clearances) - 1])
            translate([-22.5 + i * 15, 0, coupon_h - tray_magnet_h - magnet_h_clearance])
                cylinder(d = tray_magnet_d + clearances[i],
                         h = tray_magnet_h + magnet_h_clearance + epsilon);
    }
}
