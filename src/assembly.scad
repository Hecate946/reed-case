include <parts/shell.scad>
include <parts/reed_plate.scad>
include <parts/hardware_parts.scad>
include <parts/calibration.scad>

module reed_placeholder() {
    color([0.76, 0.58, 0.30, 0.85])
        linear_extrude(height = reed_max_h)
            hull() {
                translate([0, -reed_length / 2 + 5]) circle(d = 10.5);
                translate([0,  reed_length / 2 - 5]) circle(d = reed_max_w);
            }
}

module pack_placeholder() {
    color([0.82, 0.80, 0.73, 0.75])
        rounded_prism([boveda_w, boveda_d, boveda_h], 2.0);
}

module populated_plate() {
    color([0.18, 0.20, 0.23]) reed_plate();
    for (i = [0 : reeds_per_plate - 1])
        translate([lane_x(i), 0, tray_t + rail_h]) reed_placeholder();
}

module tray_stack(z0 = floor_t + 1.2, exploded = false) {
    color([0.82, 0.80, 0.73, 0.75])
        translate([0, body_y, z0]) pack_placeholder();
    first_z = z0 + boveda_h + 0.20;
    for (level = [0 : plates_per_half - 1])
        translate([0, body_y,
                   first_z + level * (tray_t + rail_h + reed_max_h +
                                      (exploded ? exploded_gap : tray_stack_gap))])
            populated_plate();
}

module closed_assembly(exploded = false) {
    color([0.10, 0.12, 0.15]) base_shell();
    tray_stack(floor_t, exploded);

    lid_z = base_h + lid_h + (exploded ? exploded_gap * 3 : 0);
    translate([0, 0, lid_z])
        mirror([0, 0, 1]) {
            color([0.13, 0.15, 0.18, 0.88]) lid_shell();
            tray_stack(floor_t, exploded);
        }

    color([0.70, 0.72, 0.75])
        translate([-(case_w - 2 * hinge_edge_margin) / 2 - 0.75,
                   -case_d / 2 + hinge_outer_d / 2,
                   base_h])
            rotate([0, 90, 0]) hinge_pin();
}

module print_layout() {
    spacing = max(case_w, case_d) + 12;
    translate([-spacing / 2, 0, 0]) base_shell();
    translate([ spacing / 2, 0, 0]) lid_shell();
    translate([-spacing / 2, case_d + 15, 0]) reed_plate();
    translate([ spacing / 2, case_d + 15, 0]) reed_plate();
}

module render_selected(which) {
    if (which == "base") base_shell();
    else if (which == "lid") lid_shell();
    else if (which == "reed_plate") reed_plate();
    else if (which == "retainer_strip") retainer_strip();
    else if (which == "hinge_pin") hinge_pin();
    else if (which == "latch_clip") latch_clip();
    else if (which == "gasket_coupon") gasket_coupon();
    else if (which == "tolerance_coupon") tolerance_coupon();
    else if (which == "print_layout") print_layout();
    else if (which == "exploded") closed_assembly(true);
    else if (which == "assembly") closed_assembly(false);
    else assert(false, str("Unknown part: ", which));
}
