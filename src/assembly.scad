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

module bottom_case_view() {
    // Bottom case only. The front mount strip appears at the bottom of the
    // OpenSCAD view, matching the supplied sketch. Orange mounts are the actual
    // printable solids already fused into case_base, not debug placeholders.
    rotate([0, 0, 180]) {
        color(case_teal) case_base_body();
        color([0.82, 0.48, 0.12]) installed_leaf_spring_mounts();
        color([0.70, 0.58, 0.28]) installed_latch_piece();
    }
}

module bottom_case_shell_view() {
    // Printable base with its front-wall button opening, but without the
    // separate moving latch component installed. The bottom floor stays intact.
    rotate([0, 0, 180]) color(case_teal) case_base();
}

module bottom_case_latch_fit_view() {
    // Transparent fit view shows the intact floor and front-wall button opening
    // around the separately colored moving component.
    rotate([0, 0, 180]) {
        color([case_teal[0], case_teal[1], case_teal[2], 0.35]) case_base();
        color([0.70, 0.58, 0.28]) installed_latch_piece();
    }
}

module bottom_case_latch_pressed_view() {
    // Maximum inward position created by either the closing lid wall or a
    // finger pressing the exterior button. The hook is fully retracted.
    rotate([0, 0, 180]) {
        color([case_teal[0], case_teal[1], case_teal[2], 0.35]) case_base();
        color([0.82, 0.62, 0.24])
            installed_latch_piece(latch_inward_travel);
    }
}

module latch_system_detail_view(inward_travel = 0, lid_lift = 0) {
    // Isolated catch/groove relationship. The translucent blue shape is only
    // the empty groove volume. lid_lift = 0 is the fully pressed lid; at rest
    // the seal lifts it by latch_lid_rest_lift onto the flat catch underside.
    rotate([0, 0, 180]) {
        color([0.82, 0.62, 0.24])
            installed_latch_piece(inward_travel);
        color([0.25, 0.55, 0.78, 0.40])
            translate([0, 0, lid_lift])
                lid_closed_position()
                    lid_latch_groove_volume();
    }
}

module top_lid_latch_structure_view() {
    // Center-front section of the actual printable lid in its natural print
    // orientation. The blue overlay identifies the empty recessed groove; no
    // striker or other catch protrudes from the lid.
    section_w = 44;
    section_d = 17;

    color([case_teal[0], case_teal[1], case_teal[2], 0.30])
        intersection() {
            case_lid();
            translate([-section_w / 2,
                       v2_case_d / 2 - section_d,
                       0])
                cube([section_w, section_d, v2_lid_h + epsilon]);
        }
    color([0.25, 0.55, 0.78, 0.40]) lid_latch_groove_volume();
}

module bottom_case_boveda_size_60_view() {
    // Bare bottom tray shell with one official-footprint Size 60 packet centered
    // on the interior floor. The latch and spring mounts are intentionally
    // hidden in this scale-only view. Long side runs left-to-right.
    rotate([0, 0, 180]) {
        color(case_teal) case_base_body();
        translate([0, 0, v2_base_floor_t])
            boveda_size_60_placeholder();
    }
}

module latch_fit_interference_check(inward_travel = 0) {
    // Expected to render empty. Kept as a private CLI verification route so
    // future parameter edits can detect latch/base collisions immediately.
    intersection() {
        case_base();
        installed_latch_piece(inward_travel);
    }
}

module latch_groove_engagement_check(inward_travel = 0, lid_lift = 0) {
    // Locked should be non-empty because the catch occupies the groove. Fully
    // pressed should be empty because the catch retracts behind the lid wall.
    intersection() {
        installed_latch_piece(inward_travel);
        translate([0, 0, lid_lift])
            lid_closed_position()
                lid_latch_groove_volume();
    }
}

module latch_complete_lid_interference_check(inward_travel = 0,
                                             lid_lift = 0) {
    // Expected to render empty; checks the tongue against the complete closed
    // lid after the recessed groove has been subtracted.
    intersection() {
        installed_latch_piece(inward_travel);
        translate([0, 0, lid_lift])
            lid_closed_position()
                case_lid();
    }
}

function latch_closing_sample_lift(i) =
    latch_catch_height * i / 5;

module latch_closing_path_interference_check() {
    // Six lid heights along the closing stroke with the latch held at full
    // press. Expected to render empty: if the button can always be pushed all
    // the way in, the lid can always come down.
    for (i = [0 : 5])
        latch_complete_lid_interference_check(
            latch_inward_travel,
            latch_closing_sample_lift(i));
}

module leaf_spring_mount_pair_view() {
    // Standalone exact-mirror stepped solids for quick iteration.
    color([0.82, 0.48, 0.12]) {
        translate([leaf_spring_mount_centers_x[0], 0, 0])
            left_leaf_spring_mount();
        translate([leaf_spring_mount_centers_x[1], 0, 0])
            right_leaf_spring_mount();
    }
}

module case_closed_view(show_trays = true) {
    color(case_teal) case_base();
    color([0.70, 0.58, 0.28]) installed_latch_piece();
    if (show_trays) seated_trays(false);
    lid_closed_position() color(case_teal) case_lid();
    hinge_pin_placeholder();
}

module case_open_view(show_contents = true) {
    color(case_teal) case_base();
    color([0.70, 0.58, 0.28]) installed_latch_piece();
    seated_trays(show_contents);
    lid_open_position() color(case_teal) case_lid();
    hinge_pin_placeholder();
}

module case_exploded_view(show_contents = false) {
    color(case_teal) case_base();
    color([0.70, 0.58, 0.28]) installed_latch_piece();

    for (x = [-v2_tray_x, v2_tray_x])
        translate([x, v2_tray_y,
                   v2_tray_seated_z + exploded_gap])
            oriented_tray(show_contents);

    translate([0, 0, v2_case_h + 2 * exploded_gap])
        mirror([0, 0, 1])
            color(case_teal) case_lid();
}

module case_closed_front_view() {
    rotate([0, 0, 180]) case_closed_view(true);
}

module bottom_case_with_trays_view() {
    color(case_teal) case_base();
    color([0.70, 0.58, 0.28]) installed_latch_piece();
    seated_trays(false);
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
    else if (which == "bottom_case_latch_fit") bottom_case_latch_fit_view();
    else if (which == "bottom_case_latch_pressed" ||
             which == "bottom_case_latch_cammed")
        bottom_case_latch_pressed_view();
    else if (which == "bottom_case_boveda_size_60")
        bottom_case_boveda_size_60_view();
    else if (which == "latch_piece") latch_piece();
    else if (which == "latch_groove_lock_detail" ||
             which == "latch_lock_detail")
        latch_system_detail_view(0, latch_lid_rest_lift);
    else if (which == "latch_groove_closing_entry" ||
             which == "latch_closing_entry_detail")
        latch_system_detail_view(0, 0);
    else if (which == "latch_button_release_detail" ||
             which == "latch_release_detail")
        latch_system_detail_view(latch_inward_travel, 0);
    else if (which == "top_lid_latch_groove" ||
             which == "top_lid_latch_structure")
        top_lid_latch_structure_view();
    else if (which == "_latch_fit_interference")
        latch_fit_interference_check();
    else if (which == "_latch_pressed_base_interference")
        latch_fit_interference_check(latch_inward_travel);
    else if (which == "_latch_groove_locked_engagement")
        latch_groove_engagement_check(0, latch_lid_rest_lift);
    else if (which == "_latch_groove_pressed_engagement")
        latch_groove_engagement_check(latch_inward_travel, 0);
    else if (which == "_latch_complete_lid_locked_interference")
        // Seated on the flat land the two surfaces are exactly coplanar, so
        // this samples one hair below the seat: any solid here is a real
        // collision rather than the intended contact patch.
        latch_complete_lid_interference_check(
            0, latch_lid_rest_lift - latch_seat_check_relief);
    else if (which == "_latch_complete_lid_entry_interference")
        latch_complete_lid_interference_check(0, 0);
    else if (which == "_latch_complete_lid_released_interference")
        latch_complete_lid_interference_check(latch_inward_travel, 0);
    else if (which == "_latch_closing_path_interference")
        latch_closing_path_interference_check();
    else if (which == "leaf_spring_mount_pair") leaf_spring_mount_pair_view();
    else if (which == "left_leaf_spring_mount") left_leaf_spring_mount();
    else if (which == "right_leaf_spring_mount") right_leaf_spring_mount();
    else if (which == "lid_seal") lid_seal_view();
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
