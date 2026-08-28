include <../lib/geometry.scad>

module hinge_pin() {
    usable = case_w - 2 * hinge_edge_margin;
    pin_len = usable + 1.5;
    union() {
        chamfered_cylinder(hinge_pin_d, pin_len, 0.18);
        cylinder(d = hinge_pin_d + 2.2, h = 0.7);
    }
}

module latch_clip() {
    inner_w = latch_w + 2 * latch_clearance;
    inner_h = 2 * latch_lug_h + latch_clearance;
    clip_depth = 7.0;
    difference() {
        rounded_prism([inner_w + 2 * latch_t,
                       clip_depth,
                       inner_h + 2 * latch_t], 1.0);
        translate([0, -latch_t, latch_t])
            rounded_prism([inner_w,
                           clip_depth + 2 * epsilon,
                           inner_h + latch_t + epsilon], 0.6);
        // Finger relief.
        translate([0, clip_depth / 2, (inner_h + 2 * latch_t) / 2])
            rotate([90, 0, 0])
                cylinder(d = inner_w * 0.45, h = latch_t + 2 * epsilon,
                         center = true);
    }
}

