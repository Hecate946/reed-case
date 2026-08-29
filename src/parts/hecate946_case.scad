/*
  HECATE946 enclosure.

  - Two current five-lane Behn-style trays sit side-by-side in shallow wells.
  - Provisional hygrometer pocket at far left.
  - Eight D4x2 hardware pockets in the base floor align exactly with the tray
    pockets, regardless of which tray face is placed downward.
  - Full perimeter groove for a standard 185 x 2 mm silicone O-ring.
  - Two front click latches.
  - Minimal C-clips snap onto a 2.0 mm metal hinge axle.
*/

include <../lib/geometry.scad>
include <../lib/hardware.scad>

module hecate_body_cup(h) {
    rounded_cup(hecate_case_w, hecate_body_d, h,
                hecate_corner_r, hecate_wall, hecate_floor_t);
}

module hecate_tray_recess_2d() {
    offset(r = hecate_tray_recess_r)
        square([hecate_tray_recess_w - 2 * hecate_tray_recess_r,
                hecate_tray_recess_d - 2 * hecate_tray_recess_r],
               center = true);
}

module hecate_tray_well_cut(x) {
    translate([x, hecate_tray_y,
               hecate_floor_t - hecate_tray_recess_depth])
        linear_extrude(height = hecate_tray_recess_depth + epsilon)
            hecate_tray_recess_2d();
}

module hecate_hygro_well_cut() {
    translate([hecate_hygro_x, 0,
               hecate_floor_t - hecate_hygro_recess_depth])
        rounded_prism([hecate_hygro_slot_w, hecate_hygro_slot_d,
                       hecate_hygro_recess_depth + epsilon],
                      hecate_hygro_corner_r);
}

module hecate_partition_rib(x) {
    // Full-height structural wall between neighboring bays. It grows directly
    // out of the interior floor, reaches the base seam, and spans the full
    // interior depth into the front/rear shell walls. This makes the humidity
    // bay and both tray bays mechanically distinct and braces the wide base.
    translate([x, 0, hecate_floor_t - epsilon])
        rounded_prism([hecate_divider_t, hecate_inner_d + 2 * epsilon,
                       hecate_divider_h + epsilon],
                      hecate_divider_r);
}

module hecate_partition_ribs() {
    hecate_partition_rib(hecate_hygro_divider_x);
    hecate_partition_rib(hecate_tray_divider_x);
}

module hecate_floor_hardware_pockets(x0) {
    pocket_z = hecate_floor_t - hecate_tray_recess_depth -
               hecate_floor_magnet_depth;
    for (sx = [-1, 1], sy = [-1, 1])
        translate([x0 + sx * tray_magnet_x,
                   hecate_tray_y + sy * tray_magnet_y,
                   pocket_z])
            magnet_pocket();
}

module hecate_hinge_root(x, length, top_z) {
    // Short bridge between the external bearing and the shell. Keeping the
    // bridge entirely BELOW the local seam means base roots stay in the base
    // and lid roots (after the lid is flipped closed) stay in the lid.
    wall_y = -hecate_body_d / 2;
    ring_front_y = hecate_hinge_y + hecate_hinge_clip_outer_d / 2;
    root_y = (wall_y + ring_front_y) / 2;
    root_d = abs(wall_y - ring_front_y) + hecate_hinge_root_depth;
    translate([x, root_y, top_z - hecate_hinge_root_h])
        rounded_prism([length, root_d, hecate_hinge_root_h + epsilon], 0.45);
}

module hecate_base_hinge() {
    // Four short printed bearings hold the metal axle. Most of the rod remains
    // exposed so the lid only needs three small snap clips rather than a long
    // interleaved barrel. The barrels sit fully outside the lid wall, avoiding
    // the bulky seam reliefs used by the previous hinge.
    for (x = hecate_hinge_support_xs) {
        translate([x, hecate_hinge_y, hecate_base_h])
            hinge_barrel(hecate_hinge_support_len,
                         hecate_hinge_support_outer_d,
                         hecate_hinge_bore_d);
        hecate_hinge_root(x, hecate_hinge_support_len, hecate_base_h);
    }
}

module hecate_snap_clip(length = hecate_hinge_clip_len,
                        mouth = hecate_hinge_clip_mouth) {
    // C-shaped bearing around the metal rod. In lid print orientation the
    // mouth points +Z. Once the lid is mirrored into the closed position that
    // mouth points downward, so the lid can simply be pressed onto the axle.
    // The ring covers more than 180 degrees of the pin and then rotates on the
    // metal surface during normal opening/closing.
    difference() {
        hinge_barrel(length, hecate_hinge_clip_outer_d,
                     hecate_hinge_clip_bore_d);

        // Open a narrow path from the bore to the outside. Because `mouth` is
        // smaller than the 2 mm axle, the two rounded lips flex apart during
        // assembly and spring back behind it.
        translate([-length / 2 - epsilon,
                   -mouth / 2,
                   0])
            cube([length + 2 * epsilon,
                  mouth,
                  hecate_hinge_clip_outer_d / 2 + 2 * epsilon]);
    }
}

module hecate_lid_hinge() {
    for (x = hecate_hinge_clip_xs) {
        translate([x, hecate_hinge_y, hecate_lid_h])
            hecate_snap_clip();
        hecate_hinge_root(x, hecate_hinge_clip_len, hecate_lid_h);
    }
}

module hecate_base_catch(x) {
    // Rounded catch bar. Its upper nose gives the lid hook a ramp to ride over
    // and the underside gives the click a positive retaining shoulder.
    y0 = hecate_body_d / 2 + hecate_latch_catch_depth / 2 - 0.25;
    z0 = hecate_base_h - 3.15;
    translate([x, y0, z0])
        rounded_prism([hecate_latch_arm_w + 1.2,
                       hecate_latch_catch_depth,
                       hecate_latch_catch_h], 0.55);
}

module hecate_lid_snap_arm(x) {
    // Defined in LID PRINT orientation. After the lid is flipped closed, the
    // thin arm hangs down OUTSIDE the base catch rather than intersecting it.
    // Only the small inward hook reaches beneath the catch. The short root
    // bridge lives entirely on the lid side of the seam and anchors the arm.
    front_y = hecate_body_d / 2;
    arm_y = front_y + 2.45;
    // Anchor high on the CLOSED lid (low Z in print orientation) so the
    // flexible length is ~12 mm instead of a brittle short tab.
    arm_z0 = 2.50;
    arm_h = hecate_lid_h + hecate_latch_arm_len - arm_z0;

    union() {
        // Flexible vertical arm, clear of the catch by ~0.1 mm in Y.
        translate([x, arm_y, arm_z0])
            rounded_prism([hecate_latch_arm_w,
                           hecate_latch_arm_t,
                           arm_h], 0.55);

        // Root bridge from the lid wall to the arm. In the CLOSED case this
        // sits above the seam, so it never crosses the base catch.
        translate([x, front_y + 1.15, arm_z0])
            rounded_prism([hecate_latch_arm_w,
                           2.6, 3.2], 0.55);

        // Inward-facing hook at the free end. Its top surface closes just
        // below the catch underside, retaining the lid after the audible click.
        translate([x,
                   front_y + 1.35,
                   hecate_lid_h + hecate_latch_arm_len -
                   hecate_latch_hook_h])
            rounded_prism([hecate_latch_arm_w - 2.0,
                           1.9,
                           hecate_latch_hook_h], 0.40);

        // Outward finger pad for release.
        translate([x,
                   arm_y + hecate_latch_arm_t / 2 + 0.55,
                   hecate_lid_h + hecate_latch_arm_len - 1.6])
            rounded_prism([hecate_latch_arm_w - 3.0,
                           1.5, 1.6], 0.45);
    }
}

module hecate_gasket_groove_cut() {
    // Entirely inside the 3.2 mm rim: 0.50 mm land outside and inside a
    // 2.20 mm groove. A standard 185 mm ID x 2 mm silicone O-ring is gently
    // stretched around this rounded-rectangle path. It sits 1.50 mm deep,
    // leaving 0.50 mm proud for ~25% compression against the flat base rim.
    translate([0, 0, hecate_lid_h - hecate_gasket_groove_d])
        rounded_ring(hecate_case_w - 2 * hecate_gasket_outer_inset,
                     hecate_body_d - 2 * hecate_gasket_outer_inset,
                     hecate_corner_r - hecate_gasket_outer_inset,
                     hecate_gasket_groove_w,
                     hecate_gasket_groove_d + epsilon);
}

module hecate946_base() {
    difference() {
        union() {
            hecate_body_cup(hecate_base_h);
            hecate_partition_ribs();
            hecate_base_hinge();
            for (x = hecate_latch_xs) hecate_base_catch(x);
        }


        // Exact side-by-side tray locating wells.
        hecate_tray_well_cut(hecate_tray1_x);
        hecate_tray_well_cut(hecate_tray2_x);

        // Provisional reader slot at far left.
        hecate_hygro_well_cut();

        // Hardware targets exactly under all eight tray pockets.
        hecate_floor_hardware_pockets(hecate_tray1_x);
        hecate_floor_hardware_pockets(hecate_tray2_x);
    }
}

module hecate946_lid() {
    difference() {
        union() {
            hecate_body_cup(hecate_lid_h);
            hecate_lid_hinge();
            for (x = hecate_latch_xs) hecate_lid_snap_arm(x);
        }
        hecate_gasket_groove_cut();
    }
}

module hecate946_metal_pin_placeholder() {
    color([0.65, 0.67, 0.70])
        translate([-hecate_hinge_pin_len / 2,
                   hecate_hinge_y, hecate_base_h])
            rotate([0, 90, 0])
                cylinder(d = hecate_hinge_pin_d,
                         h = hecate_hinge_pin_len,
                         $fn = $preview ? 20 : 40);
}

module hecate946_hinge_coupon() {
    // Three production-style C clips with slightly different mouths. Snap a
    // real 2.0 mm rod into them before committing to the full lid. The centre
    // clip (1.55 mm mouth) is the production setting.
    mouths = [1.45, hecate_hinge_clip_mouth, 1.65];
    for (i = [0 : len(mouths) - 1]) {
        x = (i - 1) * 18;
        // Small anchor block duplicates the way the actual clip grows out of
        // the rear lid wall.
        translate([x, 2.5, 0])
            rounded_prism([hecate_hinge_clip_len, 5.0, 3.2], 0.7);
        translate([x, 0, 3.2])
            hecate_snap_clip(hecate_hinge_clip_len, mouths[i]);
    }
}

module hecate946_gasket_placeholder() {
    // Preview-only nominal 2 mm O-ring centreline. The actual circular 2x185
    // ring stretches ~1.8% to follow this rounded rectangular path.
    color([0.85, 0.25, 0.18, 0.75])
        translate([0, 0, hecate_lid_h - hecate_gasket_groove_d +
                         hecate_gasket_d / 2])
            rounded_ring(hecate_case_w - 2 * hecate_gasket_outer_inset -
                         hecate_gasket_groove_w + hecate_gasket_d,
                         hecate_body_d - 2 * hecate_gasket_outer_inset -
                         hecate_gasket_groove_w + hecate_gasket_d,
                         hecate_corner_r - hecate_gasket_outer_inset -
                         hecate_gasket_groove_w / 2 +
                         hecate_gasket_d / 2,
                         hecate_gasket_d,
                         0.35);
}

module hecate946_seal_view() {
    // Lid in print orientation with the gasket shown seated in its groove.
    color([0.12, 0.13, 0.16, 0.92]) hecate946_lid();
    hecate946_gasket_placeholder();
}

module hecate946_oriented_tray() {
    // HECATE946 opens on the +Y click-latch side; the hinge is on -Y.
    // The standalone Behn tray's open reed-insertion/heel end is -Y, so the
    // nested enclosure view rotates the tray 180 degrees. The reed insertion
    // mouths now face the side of the box that opens. This does NOT alter the
    // standalone Behn tray STL or its magnet-pocket geometry.
    rotate([0, 0, 180]) behn_tray();
}

module hecate946_tray_placeholders(show_detail = true) {
    for (x = [hecate_tray1_x, hecate_tray2_x])
        translate([x, hecate_tray_y, hecate_tray_seated_z])
            if (show_detail)
                hecate946_oriented_tray();
            else
                color([0.18, 0.20, 0.23, 0.55])
                    translate([0, 0, -hecate_tray_bottom_offset])
                        rounded_prism([tray_body_w, tray_d, tray_total_h],
                                      tray_body_corner_r);
}

module hecate946_hygrometer_placeholder() {
    // Deliberately generic: the real hygrometer bay will be edited once the
    // exact reader is chosen.  This is preview-only and never part of an STL.
    color([0.45, 0.48, 0.52, 0.70])
        translate([hecate_hygro_x, 0,
                   hecate_floor_t - hecate_hygro_recess_depth])
            rounded_prism([hecate_hygro_slot_w - 0.8,
                           hecate_hygro_slot_d - 0.8, 3.2],
                          max(hecate_hygro_corner_r - 0.4, 0.5));
}

module hecate946_nested_trays(show_hygrometer = true) {
    // Best fit-check view: lid omitted so both COMPLETE Behn trays are visibly
    // seated in their real case wells, with the new structural dividers in
    // between.
    color([0.09, 0.10, 0.12]) hecate946_base();
    hecate946_tray_placeholders(true);
    if (show_hygrometer) hecate946_hygrometer_placeholder();
}

module hecate946_nested_trays_exploded(show_hygrometer = true) {
    // Same footprint as the nested view, but lifts the trays above the base so
    // the two locating wells, divider ribs and hardware-pocket registration
    // can be inspected without hiding them.
    color([0.09, 0.10, 0.12]) hecate946_base();
    if (show_hygrometer) hecate946_hygrometer_placeholder();
    for (x = [hecate_tray1_x, hecate_tray2_x])
        translate([x, hecate_tray_y,
                   hecate_tray_seated_z + 18])
            hecate946_oriented_tray();
}

module hecate946_one_tray_fit() {
    // Useful close inspection view: left well exposed, right tray seated.
    color([0.09, 0.10, 0.12]) hecate946_base();
    translate([hecate_tray2_x, hecate_tray_y, hecate_tray_seated_z])
        hecate946_oriented_tray();
    hecate946_hygrometer_placeholder();
}

module hecate946_closed_assembly(show_trays = true) {
    color([0.09, 0.10, 0.12]) hecate946_base();
    if (show_trays) hecate946_tray_placeholders(true);

    translate([0, 0, hecate_case_h])
        mirror([0, 0, 1])
            color([0.12, 0.13, 0.16, 0.90]) hecate946_lid();

    hecate946_metal_pin_placeholder();
}

module hecate946_open_layout() {
    // Print-orientation layout. Lid and base each remain cup-up and support
    // friendly. The 12 mm gap is just for preview/export convenience.
    translate([0, -(hecate_body_d + 12) / 2, 0]) hecate946_base();
    translate([0,  (hecate_body_d + 12) / 2, 0]) hecate946_lid();
}
module hecate946_shell_closed() {
    hecate946_closed_assembly(false);
}

