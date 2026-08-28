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
    color([0.82, 0.80, 0.73, 0.72])
        rounded_prism([boveda_w, boveda_d, boveda_h], 2.0);
}

module face_reeds(up = true) {
    for (i = [0 : reeds_per_face - 1])
        if (up)
            translate([lane_x(i), 0, tray_face_t + rail_h])
                reed_placeholder();
        else
            mirror([0, 0, 1])
                translate([lane_x(i), 0, tray_face_t + rail_h])
                    reed_placeholder();
}

module elastic_band_placeholder(y) {
    band_t = 0.8;
    band_w = 1.8;
    color([0.05, 0.05, 0.05]) {
        translate([0, y, tray_core_h + tray_face_t + tray_guide_h - band_t / 2])
            cube([tray_w + 1.0, band_w, band_t], center = true);
        translate([0, y, -tray_face_t - tray_guide_h + band_t / 2])
            cube([tray_w + 1.0, band_w, band_t], center = true);
    }
}

module populated_behn_tray(show_pack = true) {
    behn_tray();
    if (show_pack)
        translate([0, tray_pack_seated_y,
                   (tray_core_h - boveda_h) / 2])
            pack_placeholder();
    translate([0, 0, tray_core_h]) face_reeds(true);
    face_reeds(false);
    for (p = elastic_band_positions)
        elastic_band_placeholder(p * reed_length);
}

module patent_tray_exploded() {
    translate([0, 0, -exploded_gap])
        mirror([0, 0, 1]) behn_tray_face();
    behn_tray_core();
    translate([0, 0, tray_core_h + exploded_gap]) behn_tray_face();
    translate([0, tray_pack_seated_y,
               (tray_core_h - boveda_h) / 2])
        pack_placeholder();
}

module pack_insertion_demo() {
    // Pack is shown partially inserted through the +Y rear-frame opening.
    demo_extension = boveda_d * 0.38;
    color([0.16, 0.18, 0.21, 0.45]) behn_tray_core();
    color([0.32, 0.35, 0.40]) {
        translate([0, 0, tray_core_h]) {
            patent_pack_stop_half_ribs();
        }
        mirror([0, 0, 1]) {
            patent_pack_stop_half_ribs();
        }
    }
    translate([0, tray_pack_seated_y + demo_extension,
               (tray_core_h - boveda_h) / 2])
        pack_placeholder();
}

module patent_tray_stack(exploded = false) {
    tray_origin = floor_t + 0.4 + tray_face_t + tray_guide_h;
    for (level = [0 : tray_count - 1])
        translate([0, body_y,
                   tray_origin + level *
                   (tray_total_h + (exploded ? exploded_gap : tray_stack_gap))])
            populated_behn_tray(true);
}

module closed_assembly(exploded = false) {
    color([0.10, 0.12, 0.15]) base_shell();
    patent_tray_stack(exploded);

    lid_z = base_h + lid_h + (exploded ? exploded_gap * 3 : 0);
    translate([0, 0, lid_z])
        mirror([0, 0, 1])
            color([0.13, 0.15, 0.18, 0.88]) lid_shell();

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
    translate([-spacing / 2, case_d + 15, 0]) behn_tray_face();
    translate([ spacing / 2, case_d + 15, 0]) behn_tray_core();
}

module render_selected(which) {
    if (which == "base") base_shell();
    else if (which == "lid") lid_shell();
    else if (which == "behn_tray_face" || which == "reed_plate") behn_tray_face();
    else if (which == "behn_tray_core") behn_tray_core();
    else if (which == "behn_tray") behn_tray();
    else if (which == "populated_behn_tray") populated_behn_tray(true);
    else if (which == "pack_insertion_demo") pack_insertion_demo();
    else if (which == "patent_tray_exploded") patent_tray_exploded();
    else if (which == "behn_tray_stack") patent_tray_stack(false);
    else if (which == "hinge_pin") hinge_pin();
    else if (which == "latch_clip") latch_clip();
    else if (which == "gasket_coupon") gasket_coupon();
    else if (which == "tolerance_coupon") tolerance_coupon();
    else if (which == "print_layout") print_layout();
    else if (which == "exploded") closed_assembly(true);
    else if (which == "assembly") closed_assembly(false);
    else assert(false, str("Unknown part: ", which));
}
