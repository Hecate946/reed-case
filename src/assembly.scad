include <parts/tray.scad>
include <parts/case.scad>
include <parts/calibration.scad>

// Preview palette only. STL exports are unaffected.
case_teal = [0.025, 0.19, 0.22];
tray_white = [0.96, 0.96, 0.94];
pack_tan = [0.78, 0.74, 0.65, 0.85];
reed_cane = [0.78, 0.58, 0.30, 0.94];
hardware_silver = [0.76, 0.78, 0.80];

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

module boveda_size_8_placeholder(label = true) {
    color([0.72, 0.56, 0.28, 0.92])
        rounded_prism([boveda_w, boveda_d, boveda_h], 2.0);

    if (label)
        color([0.30, 0.22, 0.11])
            translate([0, 0, boveda_h + epsilon])
                linear_extrude(height = 0.12)
                    text("BOVEDA SIZE 8",
                         size = 5.0,
                         font = "Liberation Sans:style=Bold",
                         halign = "center",
                         valign = "center");
}

module boveda_size_60_placeholder() {
    color([0.72, 0.56, 0.28, 0.92])
        rounded_prism([boveda_size_60_w,
                       boveda_size_60_d,
                       boveda_size_60_h_preview],
                      boveda_size_60_corner_r_preview);

    // Preview-only label makes the scale object unmistakable. It is never
    // included in any printable STL export.
    color([0.30, 0.22, 0.11])
        translate([0, 0, boveda_size_60_h_preview + epsilon])
            linear_extrude(height = 0.12)
                text("BOVEDA SIZE 60",
                     size = 8.0,
                     font = "Liberation Sans:style=Bold",
                     halign = "center",
                     valign = "center");
}

module tray_o_ring_placeholder() {
    // Preview only. Show both independent 2 mm silicone loops at the 40% and
    // 50% snap rows. The straight spans intentionally pass through the reed
    // preview slightly: real silicone bows upward over each reed, and that
    // deflection is the preload that holds the reed down.
    r = tray_o_ring_cord_r_open();
    x = tray_body_w_open() / 2;
    join = tray_face_join_overlap_open();
    z_top = -join / 2 + tray_o_ring_snap_center_z_open();
    z_bottom = join / 2 - tray_o_ring_snap_center_z_open();

    color([0.14, 0.14, 0.14, 0.95])
        for (fraction = tray_o_ring_fractions_open) {
            y = tray_o_ring_y_open(fraction);

            for (z = [z_bottom, z_top])
                translate([-x, y, z])
                    rotate([0, 90, 0])
                        cylinder(r = r, h = 2 * x,
                                 $fn = is_fast_mesh ? 20 : 40);

            for (side = [-1, 1])
                translate([side * x, y, z_bottom])
                    cylinder(r = r, h = z_top - z_bottom,
                             $fn = is_fast_mesh ? 20 : 40);

            for (side = [-1, 1], z = [z_bottom, z_top])
                translate([side * x, y, z])
                    sphere(r = r, $fn = is_fast_mesh ? 20 : 40);
        }
}

module tray_with_reeds() {
    color(tray_white) tray();

    // Keep the test readable: show five of the ten slots on each face.
    for (side = [-1, 1], i = [2 : 6]) {
        if (side > 0)
            translate([tray_lane_x_open(i), tray_reed_center_y_open(),
                       -tray_face_join_overlap_open() / 2 +
                       tray_face_t_open() + tray_texture_h_open()])
                vandoren_traditional_35_reed();
        else
            translate([0, 0, tray_face_join_overlap_open() / 2])
                rotate([0, 180, 0])
                    translate([tray_lane_x_open(i), tray_reed_center_y_open(),
                               tray_face_t_open() + tray_texture_h_open()])
                        vandoren_traditional_35_reed();
    }

    tray_o_ring_placeholder();
}

module behn_tray_with_reeds() {
    color(tray_white) behn_tray_public();
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
    // Reed insertion/heel ends face the front catch side (+Y).
    rotate([0, 0, 180])
        if (show_contents) tray_with_reeds(); else color(tray_white) tray();
}

module oriented_behn_tray(show_contents = false) {
    rotate([0, 0, 180])
        if (show_contents) behn_tray_with_reeds();
        else color(tray_white) behn_tray_public();
}

module seated_trays(show_contents = false) {
    // Legacy plural module name retained so existing views/scripts keep
    // working; the enclosure now carries one full-width cartridge.
    translate([v2_tray_x, v2_tray_y, v2_tray_seated_z])
        oriented_tray(show_contents);
}

module humidity_bay_pack_positions() {
    pocket_center_x = (v2_humidity_bay_pocket_w +
                       v2_humidity_bay_divider_t) / 2;
    for (sx = [-1, 1])
        translate([v2_humidity_bay_x + sx * pocket_center_x,
                   v2_humidity_bay_y,
                   v2_humidity_bay_floor_z])
            children();
}

module humidity_cover_installed_preview() {
    color([0.95, 0.95, 0.95]) humidity_cover();
}

module humidity_bay_with_packs(cover_installed = true, cover_lift = 0) {
    if (cover_installed)
        color([0.95, 0.95, 0.95])
            translate([0, 0, cover_lift]) humidity_cover();

    humidity_bay_pack_positions()
        color(pack_tan)
            translate([0, 0, 0]) boveda_size_8_placeholder(false);
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

module installed_roller_catch_hardware_preview(lid_open = false) {
    color(hardware_silver) installed_alise_main_catch_preview();
    if (lid_open)
        lid_open_position() color(hardware_silver) installed_alise_strike_preview();
    else
        lid_closed_position() color(hardware_silver) installed_alise_strike_preview();
}

module roller_catch_mechanism_view() {
    color([case_teal[0], case_teal[1], case_teal[2], 0.24]) case_base();
    color(hardware_silver) installed_alise_main_catch_preview();
    lid_closed_position()
        color([case_teal[0], case_teal[1], case_teal[2], 0.18]) case_lid();
    lid_closed_position()
        color(hardware_silver) installed_alise_strike_preview();
}

module roller_catch_hardware_view() {
    color(hardware_silver) alise_main_catch_preview();
    translate([0, 20, 0]) color(hardware_silver) alise_strike_preview();
}

module bottom_case_view() {
    rotate([0, 0, 180]) {
        color(case_teal) case_base_body();
        color(hardware_silver) installed_alise_main_catch_preview();
        humidity_bay_with_packs(true);
    }
}

module bottom_case_shell_view() {
    // Printable base with the integrated Alise catch pedestal and mounting pilots.
    rotate([0, 0, 180]) color(case_teal) case_base();
}

module case_closed_view(show_trays = true) {
    color(case_teal) case_base();
    color(hardware_silver) installed_alise_main_catch_preview();
    humidity_bay_with_packs(true);
    if (show_trays) seated_trays(false);
    lid_closed_position() color(case_teal) case_lid();
    lid_closed_position() color(hardware_silver) installed_alise_strike_preview();
    hinge_pin_placeholder();
}

module case_open_view(show_contents = true) {
    color(case_teal) case_base();
    color(hardware_silver) installed_alise_main_catch_preview();
    humidity_bay_with_packs(true);
    seated_trays(show_contents);
    lid_open_position() color(case_teal) case_lid();
    lid_open_position() color(hardware_silver) installed_alise_strike_preview();
    hinge_pin_placeholder();
}

module case_exploded_view(show_contents = false) {
    color(case_teal) case_base();
    color(hardware_silver) installed_alise_main_catch_preview();

    humidity_bay_with_packs(false);
    color([0.95, 0.95, 0.95])
        translate([0, 0, exploded_gap / 2]) humidity_cover();

    translate([v2_tray_x, v2_tray_y,
               v2_tray_seated_z + exploded_gap])
        oriented_tray(show_contents);

    translate([0, 0, v2_case_h + 2 * exploded_gap])
        mirror([0, 0, 1]) {
            color(case_teal) case_lid();
            color(hardware_silver) installed_alise_strike_preview();
        }
}

module case_closed_front_view() {
    rotate([0, 0, 180]) case_closed_view(true);
}

module bottom_case_with_trays_view() {
    color(case_teal) case_base();
    color(hardware_silver) installed_alise_main_catch_preview();
    humidity_bay_with_packs(true);
    seated_trays(false);
}

module humidity_cassette_view() {
    color([case_teal[0], case_teal[1], case_teal[2], 0.22]) case_base();
    humidity_bay_with_packs(false);
    color([0.95, 0.95, 0.95])
        translate([0, 0, 8]) humidity_cover();
}

module humidity_bay_open_view() {
    // Lid removed completely so the divided Boveda wells are visible.
    color([case_teal[0], case_teal[1], case_teal[2], 0.22]) case_base();
    humidity_bay_with_packs(false);
}

module humidity_bay_closed_view() {
    color([case_teal[0], case_teal[1], case_teal[2], 0.22]) case_base();
    humidity_bay_with_packs(true);
}

module lid_seal_view() {
    color(case_teal) case_lid();
    gasket_placeholder();
}

module print_layout() {
    gap = 12;
    translate([0, -(v2_case_d + gap) / 2, 0]) case_base();
    translate([0,  (v2_case_d + gap) / 2, 0]) case_lid();
}

module render_selected(which) {
    if (which == "case_open") case_open_view(true);
    else if (which == "case_closed") case_closed_view(true);
    else if (which == "case_exploded") case_exploded_view(true);
    else if (which == "case_closed_front") case_closed_front_view();
    else if (which == "bottom_case_with_trays") bottom_case_with_trays_view();
    else if (which == "bottom_case") bottom_case_view();
    else if (which == "bottom_case_shell") bottom_case_shell_view();
    else if (which == "humidity_cassette") humidity_cassette_view();
    else if (which == "humidity_bay_open") humidity_bay_open_view();
    else if (which == "humidity_bay_closed") humidity_bay_closed_view();
    else if (which == "roller_catch_mechanism") roller_catch_mechanism_view();
    else if (which == "roller_catch_hardware") roller_catch_hardware_view();
    else if (which == "alise_main_catch") alise_main_catch_preview();
    else if (which == "alise_strike") alise_strike_preview();
    else if (which == "lid_seal") lid_seal_view();
    else if (which == "case_base") case_base();
    else if (which == "case_lid") case_lid();
    else if (which == "humidity_cover") humidity_cover();
    else if (which == "tray") tray();
    else if (which == "tray_test") tray_with_reeds();
    else if (which == "tray_face_a") tray_face_a();
    else if (which == "tray_face_b") tray_face_b();
    else if (which == "behn_tray") behn_tray_public();
    else if (which == "behn_tray_test") behn_tray_with_reeds();
    else if (which == "behn_tray_face_a") behn_tray_face_a_public();
    else if (which == "behn_tray_face_b") behn_tray_face_b_public();
    else if (which == "behn_tray_core") behn_tray_core_public();
    else if (which == "fit_coupon") fit_coupon();
    else if (which == "print_layout") print_layout();
    else assert(false, str("Unknown part/view: ", which));
}
