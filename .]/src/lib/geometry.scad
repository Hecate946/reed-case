module rounded_prism(size = [10, 10, 10], r = 2, center_xy = true) {
    x = size[0]; y = size[1]; z = size[2];
    assert(x > 2 * r && y > 2 * r && z > 0);
    linear_extrude(height = z)
        offset(r = r)
            square([x - 2 * r, y - 2 * r], center = center_xy);
}

module rounded_ring(w, d, outer_r, ring_w, h) {
    assert(ring_w > 0 && outer_r > ring_w);
    difference() {
        rounded_prism([w, d, h], outer_r);
        translate([0, 0, -epsilon])
            rounded_prism([w - 2 * ring_w, d - 2 * ring_w, h + 2 * epsilon],
                          max(outer_r - ring_w, 0.2));
    }
}

module rounded_cup(w, d, h, r, wall_t, bottom_t) {
    assert(h > bottom_t && w > 2 * wall_t && d > 2 * wall_t);
    difference() {
        rounded_prism([w, d, h], r);
        translate([0, 0, bottom_t])
            rounded_prism([w - 2 * wall_t,
                           d - 2 * wall_t,
                           h - bottom_t + epsilon],
                          max(r - wall_t, 0.5));
    }
}

module top_chamfered_extrude(height, chamfer = 0.20, steps = 3) {
    // Fine meshes keep the small top-edge chamfer. Prototype meshes omit this
    // sub-nozzle cosmetic detail; doing so cuts tray export time dramatically
    // without changing any functional fit.
    assert(height > 0);
    c = is_fast_mesh ? 0 : min(max(chamfer, 0), height / 2);
    n = max(steps, 1);
    if (c <= 0)
        linear_extrude(height = height) children();
    else {
        base_h = height - c;
        layer_h = c / n;
        linear_extrude(height = base_h + epsilon) children();
        for (i = [0 : n - 1])
            translate([0, 0, base_h + i * layer_h - epsilon])
                linear_extrude(height = layer_h + 2 * epsilon)
                    offset(delta = -c * (i + 1) / n) children();
    }
}

module capsule_2d(length, width) {
    hull() {
        translate([-(length - width) / 2, 0]) circle(d = width);
        translate([ (length - width) / 2, 0]) circle(d = width);
    }
}

module chamfered_cylinder(d, h, chamfer = 0.25) {
    rotate_extrude()
        polygon([
            [0, 0],
            [d / 2 - chamfer, 0],
            [d / 2, chamfer],
            [d / 2, h - chamfer],
            [d / 2 - chamfer, h],
            [0, h]
        ]);
}

