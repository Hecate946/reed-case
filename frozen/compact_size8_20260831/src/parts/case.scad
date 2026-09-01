/*
  Single-cartridge prototype enclosure.

  Goals:
  - one centered 10-reed-per-face H946 cartridge
  - real metal hinge pin
  - real magnets/steel targets
  - real silicone O-ring
  - centered Alise CA100S-4P double-roller catch hardware
  - no custom moving latch, button, leaf spring, or latch cover
*/

include <../lib/geometry.scad>
include <../lib/hardware.scad>
include <roller_catch.scad>

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

module v2_tray_well_cut() {
    translate([v2_tray_x, v2_tray_y,
               v2_base_floor_t - v2_tray_recess_depth])
        linear_extrude(height = v2_tray_recess_depth + epsilon)
            v2_tray_recess_2d();
}

module v2_humidity_bay_outline_2d(clearance = 0) {
    r = max(v2_tray_support_inner_r + clearance, 0.6);
    offset(r = r)
        square([v2_tray_support_inner_w + 2 * clearance - 2 * r,
                v2_tray_support_inner_d + 2 * clearance - 2 * r],
               center = true);
}

module v2_tray_support_frame_2d() {
    difference() {
        v2_tray_recess_2d();
        v2_humidity_bay_outline_2d();
    }
}

module v2_tray_support_frame() {
    translate([v2_tray_x, v2_tray_y, v2_base_floor_t])
        linear_extrude(height = v2_tray_support_h, convexity = 10)
            v2_tray_support_frame_2d();
}

module v2_floor_hardware_pockets() {
    pocket_z = v2_tray_bottom_z - v2_floor_magnet_depth;
    for (sx = [-1, 1], sy = [-1, 1])
        translate([v2_tray_x + sx * tray_magnet_x_open(),
                   v2_tray_y + sy * tray_magnet_y_open(),
                   pocket_z])
            magnet_pocket();
}

module v2_humidity_cover_base_pockets() {
    // No magnets for the humidity cover in this revision.
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

module v2_gasket_groove_cut() {
    translate([0, 0, v2_lid_h - v2_gasket_groove_d])
        rounded_ring(v2_case_w - 2 * v2_gasket_outer_land,
                     v2_case_d - 2 * v2_gasket_outer_land,
                     v2_corner_r - v2_gasket_outer_land,
                     v2_gasket_groove_w,
                     v2_gasket_groove_d + epsilon);
}

module v2_lid_engraving_cut() {
    // Anchored to the corner that reads as bottom-right when you look down at
    // the closed case with the roller catch at the front edge. The lid is mirrored in Z on
    // assembly, so the mark is laid out rotated here and comes out upright and
    // correctly handed on the finished exterior.
    if (v2_engraving_enable)
        translate([-(v2_case_w / 2 - v2_brand_margin_x),
                     v2_case_d / 2 - v2_brand_margin_y,
                    -epsilon])
            rotate([0, 0, 180])
                linear_extrude(height = v2_brand_depth + epsilon)
                    text(v2_brand_text,
                         size = v2_brand_size,
                         font = v2_brand_font,
                         halign = "right",
                         valign = "baseline");
}

module case_base_body() {
    difference() {
        union() {
            v2_case_cup(v2_base_h, v2_base_floor_t);
            v2_base_hinge();
            v2_tray_support_frame();
            installed_humidity_bay();
            roller_catch_base_boss();
        }

        v2_floor_hardware_pockets();
        v2_humidity_cover_base_pockets();
        roller_catch_base_mount_cuts();
    }
}

module case_base() {
    case_base_body();
}

module case_lid() {
    union() {
        difference() {
            union() {
                v2_case_cup(v2_lid_h, v2_lid_roof_t);
                v2_lid_hinge();
                roller_catch_lid_boss();
            }
            v2_gasket_groove_cut();
            v2_lid_engraving_cut();
            roller_catch_lid_mount_cuts();
        }
    }
}


module humidity_bay_divider_wall() {
    divider_h = v2_humidity_cover_z - v2_humidity_bay_floor_z;
    divider_d = v2_tray_support_inner_d + 2 * epsilon;
    translate([v2_humidity_bay_x - v2_humidity_bay_divider_t / 2,
               v2_humidity_bay_y - v2_tray_support_inner_d / 2 - epsilon,
               v2_humidity_bay_floor_z])
        cube([v2_humidity_bay_divider_t,
              divider_d,
              divider_h]);
}

module humidity_bay_finger_scoops() {
    scoop_r = 8.00;
    scoop_y = v2_humidity_bay_y - v2_humidity_bay_inner_d / 2;
    pocket_center_x = (v2_humidity_bay_pocket_w +
                       v2_humidity_bay_divider_t) / 2;
    for (sx = [-1, 1])
        translate([v2_humidity_bay_x + sx * pocket_center_x,
                   scoop_y,
                   v2_humidity_bay_floor_z + 0.01])
            cylinder(r = scoop_r,
                     h = v2_humidity_cover_z - v2_humidity_bay_floor_z + 0.02,
                     $fn = is_fast_mesh ? 28 : 56);
}

module humidity_bay_geometry() {
    // Center divider only; perimeter walls are provided by the tray support frame.
    difference() {
        humidity_bay_divider_wall();
        // nothing
    }
}

module humidity_cover_seat_ring() {
    seat_z = v2_humidity_cover_z - v2_humidity_cover_seat_depth;
    translate([v2_humidity_bay_x, v2_humidity_bay_y, seat_z])
        linear_extrude(height = v2_humidity_cover_seat_depth)
            difference() {
                v2_humidity_bay_outline_2d();
                r = max(v2_tray_support_inner_r - v2_humidity_cover_seat_w, 0.5);
                offset(r = r)
                    square([v2_tray_support_inner_w - 2 * v2_humidity_cover_seat_w - 2 * r,
                            v2_tray_support_inner_d - 2 * v2_humidity_cover_seat_w - 2 * r],
                           center = true);
            }
}

module humidity_cover_vents_2d() {
    // Fully contained, symmetric honeycomb field. Rows alternate between 15
    // and 16 openings; because each row is independently centered and there
    // are an odd number of rows, the pattern mirrors cleanly on both axes.
    // The field is sized to stop before the rounded perimeter and to leave a
    // solid bridge around the front semicircular finger notch, so no hexagon
    // is clipped by either feature.
    hex_half_w = v2_humidity_cover_vent_r * cos(30);
    staggered_cols = v2_humidity_cover_vent_cols + 1;
    pattern_half_w = (staggered_cols - 1) / 2 *
                     v2_humidity_cover_vent_pitch_x + hex_half_w;
    pattern_half_d = (v2_humidity_cover_vent_rows - 1) / 2 *
                     v2_humidity_cover_vent_pitch_y +
                     v2_humidity_cover_vent_r;
    vent_limit_x = v2_humidity_cover_w / 2 - v2_humidity_cover_vent_inset;
    vent_limit_y = v2_humidity_cover_d / 2 - v2_humidity_cover_vent_inset;
    finger_inner_y = v2_humidity_cover_d / 2 -
                     v2_humidity_cover_finger_inset -
                     v2_humidity_cover_finger_r;

    assert(pattern_half_w <= vent_limit_x,
           "Humidity-cover honeycomb is too wide and would clip at the ends");
    assert(pattern_half_d <= vent_limit_y,
           "Humidity-cover honeycomb is too deep and would clip at the edges");
    assert(pattern_half_d + 1.50 <= finger_inner_y,
           "Humidity-cover honeycomb is too close to the finger notch");

    union()
        for (row = [0 : v2_humidity_cover_vent_rows - 1]) {
            iy = row - (v2_humidity_cover_vent_rows - 1) / 2;
            row_cols = v2_humidity_cover_vent_cols + (row % 2);

            for (col = [0 : row_cols - 1]) {
                ix = col - (row_cols - 1) / 2;
                translate([ix * v2_humidity_cover_vent_pitch_x,
                           iy * v2_humidity_cover_vent_pitch_y])
                    rotate(30)
                        circle(r = v2_humidity_cover_vent_r, $fn = 6);
            }
        }
}

module humidity_cover() {
    translate([v2_humidity_bay_x, v2_humidity_bay_y, 0])
    difference() {
        translate([0, 0, v2_humidity_cover_z])
            rounded_prism([v2_humidity_cover_w,
                           v2_humidity_cover_d,
                           v2_humidity_cover_t],
                          v2_humidity_cover_corner_r);

        // Staggered honeycomb ventilation field.
        translate([0, 0, v2_humidity_cover_z - epsilon])
            linear_extrude(height = v2_humidity_cover_t + 2 * epsilon)
                humidity_cover_vents_2d();

        // Semicircular finger hole at the front edge.
        translate([0,
                   v2_humidity_cover_d / 2 - v2_humidity_cover_finger_inset,
                   v2_humidity_cover_z - epsilon])
            cylinder(r = v2_humidity_cover_finger_r,
                     h = v2_humidity_cover_t + 2 * epsilon,
                     $fn = is_fast_mesh ? 36 : 72);

    }
}

module installed_humidity_bay() {
    humidity_cover_seat_ring();
    humidity_bay_geometry();
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
