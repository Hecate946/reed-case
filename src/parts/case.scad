/*
  V2 prototype enclosure.

  Goals:
  - compact two-tray layout with no hygrometer bay
  - real metal hinge pin
  - real magnets/steel targets
  - real silicone O-ring
  - printed dual snap latches to evaluate click feel before selecting final
    metal closure hardware
*/

include <../lib/geometry.scad>
include <../lib/hardware.scad>

module v2_case_cup(h, floor_t) {
    rounded_cup(v2_case_w, v2_case_d, h,
                v2_corner_r, v2_wall, floor_t);
}

module v2_tray_recess_2d() {
    offset(r = v2_tray_recess_r)
        square([v2_tray_recess_w - 2 * v2_tray_recess_r,
                v2_tray_recess_d - 2 * v2_tray_recess_r],
               center = true);
}

module v2_tray_well_cut(x) {
    translate([x, v2_tray_y,
               v2_base_floor_t - v2_tray_recess_depth])
        linear_extrude(height = v2_tray_recess_depth + epsilon)
            v2_tray_recess_2d();
}

module v2_floor_hardware_pockets(x0) {
    pocket_z = v2_base_floor_t - v2_tray_recess_depth -
               v2_floor_magnet_depth;
    for (sx = [-1, 1], sy = [-1, 1])
        translate([x0 + sx * tray_magnet_x,
                   v2_tray_y + sy * tray_magnet_y,
                   pocket_z])
            magnet_pocket();
}

module v2_thumb_scoop(x) {
    // Small recess under the front edge of each tray. It never reaches the
    // exterior wall, so it does not compromise the sealed shell.
    translate([x,
               v2_tray_y + v2_tray_recess_d / 2 - 1.4,
               v2_base_floor_t - v2_tray_recess_depth - 0.75])
        cylinder(d = 16,
                 h = v2_tray_recess_depth + 1.50 + epsilon,
                 $fn = is_fast_mesh ? 32 : 64);
}

function v2_hinge_knuckle_x(i) =
    -v2_hinge_usable / 2 + v2_hinge_knuckle_len / 2 +
    i * (v2_hinge_knuckle_len + v2_hinge_gap);

module v2_hinge_root(i, shell_h) {
    wall_y = -v2_case_d / 2;
    barrel_front_y = v2_hinge_y + v2_hinge_outer_d / 2;
    root_y = (wall_y + barrel_front_y) / 2;
    root_d = v2_hinge_wall_gap + 2 * v2_hinge_root_overlap;

    translate([v2_hinge_knuckle_x(i), root_y,
               shell_h - v2_hinge_root_h])
        rounded_prism([v2_hinge_knuckle_len, root_d,
                       v2_hinge_root_h], 0.40);
}

module v2_base_hinge() {
    // Knuckles sit fully behind the shell; short roots remain entirely below
    // the seam so they cannot collide with the closed lid wall.
    for (i = [0 : v2_hinge_knuckles - 1])
        if (i % 2 == 0) {
            translate([v2_hinge_knuckle_x(i), v2_hinge_y, v2_base_h])
                hinge_barrel(v2_hinge_knuckle_len,
                             v2_hinge_outer_d,
                             v2_hinge_bore_d);
            v2_hinge_root(i, v2_base_h);
        }
}

module v2_lid_hinge() {
    // Same construction in lid print orientation. Mirroring the lid closed
    // places these roots entirely above the seam.
    for (i = [0 : v2_hinge_knuckles - 1])
        if (i % 2 == 1) {
            translate([v2_hinge_knuckle_x(i), v2_hinge_y, v2_lid_h])
                hinge_barrel(v2_hinge_knuckle_len,
                             v2_hinge_outer_d,
                             v2_hinge_bore_d);
            v2_hinge_root(i, v2_lid_h);
        }
}

module v2_base_catch(x) {
    y = v2_case_d / 2 + v2_latch_catch_d / 2 - 0.45;
    z = v2_base_h - 3.15;
    translate([x, y, z])
        rounded_prism([v2_latch_arm_w + 1.4,
                       v2_latch_catch_d,
                       v2_latch_catch_h], 0.50);
}

module v2_lid_latch(x) {
    // Defined in lid print orientation. After the lid is mirrored closed, the
    // free end points downward and the inward hook snaps beneath the catch.
    front_y = v2_case_d / 2;
    arm_y = front_y + 2.40;
    arm_z0 = 2.30;
    arm_h = v2_lid_h + v2_latch_extension - arm_z0;

    union() {
        translate([x, arm_y, arm_z0])
            rounded_prism([v2_latch_arm_w,
                           v2_latch_arm_t,
                           arm_h], 0.50);

        // Root bridge into the lid wall.
        translate([x, front_y + 1.00, arm_z0])
            rounded_prism([v2_latch_arm_w,
                           2.40, 3.20], 0.50);

        // Inward hook.
        translate([x,
                   front_y + 1.20,
                   v2_lid_h + v2_latch_extension - v2_latch_hook_h])
            rounded_prism([v2_latch_arm_w - 2.0,
                           v2_latch_hook_d,
                           v2_latch_hook_h], 0.38);

        // Tactile finger pad.
        translate([x,
                   arm_y + v2_latch_arm_t / 2 + 0.60,
                   v2_lid_h + v2_latch_extension - 1.65])
            rounded_prism([v2_latch_arm_w - 3.0,
                           1.55, 1.65], 0.42);
    }
}

module v2_gasket_groove_cut() {
    translate([0, 0, v2_lid_h - v2_gasket_groove_d])
        rounded_ring(v2_case_w - 2 * v2_gasket_outer_land,
                     v2_case_d - 2 * v2_gasket_outer_land,
                     v2_corner_r - v2_gasket_outer_land,
                     v2_gasket_groove_w,
                     v2_gasket_groove_d + epsilon);
}

module v2_lid_engraving_cut() {
    if (v2_engraving_enable)
        translate([0, 0, -epsilon])
            linear_extrude(height = v2_brand_depth + epsilon)
                text(v2_brand_text,
                     size = v2_brand_size,
                     font = v2_brand_font,
                     halign = "center",
                     valign = "center");
}

module case_base() {
    difference() {
        union() {
            v2_case_cup(v2_base_h, v2_base_floor_t);
            v2_base_hinge();
            for (x = v2_latch_xs) v2_base_catch(x);
        }

        for (x = [-v2_tray_x, v2_tray_x]) {
            v2_tray_well_cut(x);
            v2_floor_hardware_pockets(x);
            v2_thumb_scoop(x);
        }
    }
}

module case_lid() {
    difference() {
        union() {
            v2_case_cup(v2_lid_h, v2_lid_roof_t);
            v2_lid_hinge();
            for (x = v2_latch_xs) v2_lid_latch(x);
        }
        v2_gasket_groove_cut();
        v2_lid_engraving_cut();
    }
}

module hinge_pin_placeholder() {
    color([0.68, 0.70, 0.72])
        translate([-v2_hinge_pin_len / 2,
                   v2_hinge_y, v2_base_h])
            rotate([0, 90, 0])
                cylinder(d = v2_hinge_pin_d,
                         h = v2_hinge_pin_len,
                         $fn = is_fast_mesh ? 24 : 48);
}

module gasket_placeholder() {
    // Preview-only approximation of the seated round O-ring.
    color([0.08, 0.08, 0.09, 0.95])
        translate([0, 0,
                   v2_lid_h - v2_gasket_groove_d + v2_gasket_d / 2])
            rounded_ring(v2_case_w - 2 * v2_gasket_outer_land -
                         v2_gasket_groove_w + v2_gasket_d,
                         v2_case_d - 2 * v2_gasket_outer_land -
                         v2_gasket_groove_w + v2_gasket_d,
                         v2_gasket_path_r + v2_gasket_d / 2,
                         v2_gasket_d,
                         0.30);
}
