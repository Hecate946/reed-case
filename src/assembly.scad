include <parts/tray.scad>
include <parts/case.scad>
include <parts/calibration.scad>

// Preview palette only. STL exports are unaffected.
case_teal = [0.025, 0.19, 0.22];
tray_white = [0.96, 0.96, 0.94];
pack_tan = [0.78, 0.74, 0.65, 0.85];
reed_cane = [0.78, 0.58, 0.30, 0.94];

// Dimensionally grounded Vandoren Traditional Bb reed preview.
//
// Overall dimensions come from published/measured clarinet-reed geometry;
// Vandoren does not publish the exact CR1035 manufacturing profile. The model
// therefore uses the documented footprint and thickness endpoints, plus a
// smooth vamp taper, so tray clearances are physically meaningful without
// pretending we have proprietary Vandoren tooling data.
function reed_heel_y_local() = -reed_length / 2;
function reed_tip_y_local() = reed_length / 2;
function reed_vamp_start_y_local() = reed_tip_y_local() - reed_vamp_length;
function reed_tip_arc_start_y_local() = reed_tip_y_local() - reed_tip_round_depth;

function reed_width_at_y(y) =
    y <= reed_tip_arc_start_y_local()
        ? reed_heel_w + (reed_max_w - reed_heel_w) *
          ((y - reed_heel_y_local()) /
           (reed_tip_arc_start_y_local() - reed_heel_y_local()))
        : max(0.30,
              reed_max_w * sqrt(max(0, 1 - pow(
                  (y - reed_tip_arc_start_y_local()) / reed_tip_round_depth,
                  2))));

function reed_thickness_at_y(y) =
    y <= reed_vamp_start_y_local()
        ? reed_max_h
        : reed_tip_h + (reed_max_h - reed_tip_h) *
          pow(max(0, 1 -
              (y - reed_vamp_start_y_local()) / reed_vamp_length), 1.55);

module vandoren_traditional_35_reed() {
    // More longitudinal stations in fine mode make the rounded tip and vamp
    // visually smooth; prototype mode stays light enough for quick previews.
    stations = is_fast_mesh ? 14 : 30;
    ys = [for (i = [0 : stations])
          reed_heel_y_local() + reed_length * i / stations];
    widths = [for (y = ys) reed_width_at_y(y)];
    heights = [for (y = ys) reed_thickness_at_y(y)];

    // Each station contributes four vertices: bottom-left, bottom-right,
    // top-right, top-left. The underside is flat like the mouthpiece-facing
    // surface; the top follows the bark/vamp thickness profile.
    points = [for (i = [0 : stations], v = [0 : 3])
              let(y = ys[i], w = widths[i], h = heights[i])
              v == 0 ? [-w / 2, y, 0] :
              v == 1 ? [ w / 2, y, 0] :
              v == 2 ? [ w / 2, y, h] :
                       [-w / 2, y, h]];

    faces = concat(
        [[0, 1, 2, 3]],
        [for (i = [0 : stations - 1]) each [
            [4*i + 0, 4*(i+1) + 0, 4*(i+1) + 1, 4*i + 1],
            [4*i + 1, 4*(i+1) + 1, 4*(i+1) + 2, 4*i + 2],
            [4*i + 2, 4*(i+1) + 2, 4*(i+1) + 3, 4*i + 3],
            [4*i + 3, 4*(i+1) + 3, 4*(i+1) + 0, 4*i + 0]
        ]],
        [[4*stations + 3, 4*stations + 2,
          4*stations + 1, 4*stations + 0]]
    );

    color(reed_cane)
        polyhedron(points = points, faces = faces, convexity = 10);
}

module pack_placeholder() {
    color(pack_tan)
        rounded_prism([boveda_w, boveda_d, boveda_h], 2.0);
}

module populated_tray() {
    color(tray_white) tray();
    translate([0, tray_pack_seated_y, (tray_core_h - boveda_h) / 2])
        pack_placeholder();

    for (side = [-1, 1], i = [0 : reeds_per_face - 1]) {
        if (side > 0)
            translate([lane_x(i), reed_center_y(), tray_core_h +
                       tray_face_t + rail_h])
                vandoren_traditional_35_reed();
        else
            rotate([0, 180, 0])
                translate([lane_x(i), reed_center_y(),
                           tray_face_t + rail_h])
                    vandoren_traditional_35_reed();
    }
}

module oriented_tray(show_contents = false) {
    // Reed insertion/heel ends face the front latch side (+Y).
    rotate([0, 0, 180])
        if (show_contents) populated_tray(); else color(tray_white) tray();
}

module seated_trays(show_contents = false) {
    for (x = [-v2_tray_x, v2_tray_x])
        translate([x, v2_tray_y, v2_tray_seated_z])
            oriented_tray(show_contents);
}

module lid_closed_position() {
    translate([0, 0, v2_case_h])
        mirror([0, 0, 1])
            children();
}

module lid_open_position(angle = v2_open_angle) {
    translate([0, v2_hinge_y, v2_base_h])
        rotate([angle, 0, 0])
            translate([0, -v2_hinge_y, -v2_base_h])
                lid_closed_position()
                    children();
}

module v2_closed(show_trays = true) {
    color(case_teal) case_base();
    if (show_trays) seated_trays(false);
    lid_closed_position() color(case_teal) case_lid();
    hinge_pin_placeholder();
}

module v2_open(show_contents = true) {
    color(case_teal) case_base();
    seated_trays(show_contents);
    lid_open_position() color(case_teal) case_lid();
    hinge_pin_placeholder();
}

module v2_exploded(show_contents = false) {
    color(case_teal) case_base();

    for (x = [-v2_tray_x, v2_tray_x])
        translate([x, v2_tray_y,
                   v2_tray_seated_z + exploded_gap])
            oriented_tray(show_contents);

    translate([0, 0, v2_case_h + 2 * exploded_gap])
        mirror([0, 0, 1])
            color(case_teal) case_lid();
}

module v2_closed_front() {
    rotate([0, 0, 180]) v2_closed(true);
}

module v2_base_fit() {
    color(case_teal) case_base();
    seated_trays(false);
}

module v2_seal_view() {
    color(case_teal) case_lid();
    gasket_placeholder();
}

module print_layout() {
    gap = 12;
    translate([0, -(v2_case_d + gap) / 2, 0]) case_base();
    translate([0,  (v2_case_d + gap) / 2, 0]) case_lid();
}

module render_selected(which) {
    if (which == "v2_open") v2_open(true);
    else if (which == "v2_closed") v2_closed(true);
    else if (which == "v2_exploded") v2_exploded(true);
    else if (which == "v2_closed_front") v2_closed_front();
    else if (which == "v2_base_fit") v2_base_fit();
    else if (which == "v2_seal") v2_seal_view();
    else if (which == "case_base") case_base();
    else if (which == "case_lid") case_lid();
    else if (which == "tray") tray();
    else if (which == "tray_face_a") tray_face_a();
    else if (which == "tray_face_b") tray_face_b();
    else if (which == "tray_core") tray_core();
    else if (which == "fit_coupon") fit_coupon();
    else if (which == "print_layout") print_layout();
    else assert(false, str("Unknown part/view: ", which));
}
