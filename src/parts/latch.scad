/*
  Separate moving front latch.

  The rear rectangle fits between the spring-support blocks and ends exactly at
  the base seam. A thin upright carrier and outward-protruding draw hook rise
  from it. The lid contains only a recessed groove. The integral button passes
  through the front wall. The latch is never fused to the printable case base,
  so every feature remains independently adjustable.
*/

module latch_body() {
    translate([-latch_body_width / 2,
               -latch_body_depth / 2,
               0])
        cube([latch_body_width,
              latch_body_depth,
              latch_body_height]);
}

module rounded_xz_prism(width, height, depth, radius) {
    // Rounded rectangle in the visible X/Z face, extruded outward along +Y.
    // This keeps all four exterior button corners on one consistent radius.
    assert(width > 2 * radius && height > 2 * radius && depth > 0);
    rotate([-90, 0, 0])
        linear_extrude(height = depth)
            offset(r = radius)
                square([width - 2 * radius,
                        height - 2 * radius], center = true);
}

module latch_exterior_button() {
    button_start_y = latch_body_depth / 2 - latch_feature_overlap;

    translate([latch_button_center_x,
               button_start_y,
               latch_button_bottom_offset + latch_button_height / 2])
        rounded_xz_prism(latch_button_width,
                         latch_button_height,
                         latch_button_depth,
                         latch_button_corner_radius);
}

module latch_tongue_uncut() {
    seam_z = latch_body_height;
    front_y = latch_tongue_depth / 2;
    back_y = -latch_tongue_depth / 2;

    // One-sided rounded cam: horizontal near its high/back edge, smoothly
    // steepening toward the low/front edge. Unlike the old symmetric pill, the
    // The carrier keeps a restrained rounded crown; the outward draw hook below
    // is now the actual closing and locking feature.
    cam_curve = [
        for (i = [latch_tongue_cam_steps : -1 : 0])
            let(a = 90 * i / latch_tongue_cam_steps)
            [latch_tongue_cam_back_y +
                 (front_y - latch_tongue_cam_back_y) * sin(a),
             latch_tongue_height - latch_tongue_cam_drop +
                 latch_tongue_cam_drop * cos(a)]
    ];
    yz_profile = concat(
        [[back_y, 0], [front_y, 0]],
        cam_curve,
        [[back_y, latch_tongue_height - 0.45]]);

    translate([0, 0, seam_z - epsilon])
        intersection() {
            // Exact curved Y/Z closing profile, extruded across the tongue.
            multmatrix([
                [0, 0, 1, -latch_tongue_width / 2],
                [1, 0, 0,  0],
                [0, 1, 0,  0],
                [0, 0, 0,  1]
            ])
                linear_extrude(height = latch_tongue_width)
                    polygon(points = yz_profile);

            // Moderate plan rounding softens every visible corner without
            // turning the complete mechanism into another oversized capsule.
            rounded_prism([latch_tongue_width,
                           latch_tongue_depth,
                           latch_tongue_height + 2 * epsilon],
                          latch_tongue_plan_corner_radius);
        }
}

module latch_draw_hook() {
    seam_z = latch_body_height;
    root_y = latch_tongue_depth / 2 - epsilon;
    tip_y = latch_tongue_depth / 2 + latch_hook_extension;
    land_end_y = root_y + latch_hook_land_depth;
    bottom_z = seam_z + latch_hook_bottom_above_seam;
    locked_top_z = seam_z + latch_hook_locked_top_above_seam;
    entry_top_z = seam_z + latch_hook_entry_top_above_seam;

    // The flat root land holds the final sealed position. The upper surface
    // rises toward the nose by latch_draw_down. As the spring inserts this hook
    // farther into the fixed lid groove, the groove roof follows the surface
    // downward and pulls the entire lid onto the O-ring hard stop.
    hook_profile = [
        [root_y, bottom_z],
        [tip_y - latch_hook_nose_radius, bottom_z],
        [tip_y, bottom_z + latch_hook_nose_radius],
        [tip_y, entry_top_z - latch_hook_nose_radius],
        [tip_y - latch_hook_nose_radius, entry_top_z],
        [land_end_y, locked_top_z],
        [root_y, locked_top_z]
    ];

    intersection() {
        multmatrix([
            [0, 0, 1, -latch_hook_width / 2],
            [1, 0, 0,  0],
            [0, 1, 0,  0],
            [0, 0, 0,  1]
        ])
            linear_extrude(height = latch_hook_width)
                polygon(points = hook_profile);

        translate([0,
                   (root_y + tip_y) / 2,
                   bottom_z])
            rounded_prism([latch_hook_width,
                           tip_y - root_y,
                           entry_top_z - bottom_z],
                          latch_hook_plan_corner_radius);
    }
}

module latch_closing_tongue() {
    union() {
        latch_tongue_uncut();
        latch_draw_hook();
    }
}

module latch_piece() {
    union() {
        latch_body();
        latch_exterior_button();
        latch_closing_tongue();
    }
}

module installed_latch_piece(inward_travel = 0) {
    // The body sits on the interior floor. It never enters or protrudes through
    // the exterior bottom shell. Positive travel moves it inward (-Y).
    assert(inward_travel >= 0 &&
           inward_travel <= latch_inward_travel + epsilon);
    translate([0,
               latch_body_y - inward_travel,
               latch_body_bottom_z])
        latch_piece();
}

module installed_latch_guides() {
    // Two low rails constrain X motion. Mirrored inward-overlapping tabs at
    // both ends define the locked and fully-pressed stops. The rear stops make
    // the button finish exactly flush instead of allowing it to sink into the
    // wall. All solids remain below the future leaf-spring region.
    for (x = latch_guide_centers_x)
        translate([x,
                   latch_guide_y,
                   v2_base_floor_t + latch_guide_height / 2])
            cube([latch_guide_width,
                  latch_guide_depth,
                  latch_guide_height], center = true);

    for (x = latch_stop_centers_x)
        translate([x,
                   latch_stop_y,
                   v2_base_floor_t + latch_guide_height / 2])
            cube([latch_stop_width,
                  latch_stop_depth,
                  latch_guide_height], center = true);

    for (x = latch_stop_centers_x)
        translate([x,
                   latch_inward_stop_y,
                   v2_base_floor_t + latch_guide_height / 2])
            cube([latch_stop_width,
                  latch_stop_depth,
                  latch_guide_height], center = true);
}

module lid_latch_groove_volume(extra_depth = 0) {
    // Defined in lid print orientation. This is a subtraction/debug volume,
    // never a protruding physical part of the lid.
    inner_y = v2_lid_latch_groove_inner_y - epsilon;
    outer_y = v2_lid_latch_groove_outer_y + extra_depth + epsilon;
    ramp_start_y = v2_lid_latch_groove_ramp_start_y;
    ramp_end_y = v2_lid_latch_groove_ramp_end_y;
    local_inner_roof_z =
        v2_lid_h - v2_lid_latch_groove_inner_roof_above_seam;
    local_outer_roof_z =
        v2_lid_h - v2_lid_latch_groove_outer_roof_above_seam;
    local_ceiling_z =
        v2_lid_h - v2_lid_latch_groove_bottom_above_seam;

    groove_profile = [
        [inner_y, local_inner_roof_z],
        [ramp_start_y, local_inner_roof_z],
        [ramp_end_y, local_outer_roof_z],
        [outer_y, local_outer_roof_z],
        [outer_y, local_ceiling_z],
        [inner_y, local_ceiling_z]
    ];

    multmatrix([
        [0, 0, 1, -v2_lid_latch_groove_width / 2],
        [1, 0, 0,  0],
        [0, 1, 0,  0],
        [0, 0, 0,  1]
    ])
        linear_extrude(height = v2_lid_latch_groove_width)
            polygon(points = groove_profile);
}

module lid_latch_groove_cut() {
    lid_latch_groove_volume();
}

module latch_button_wall_opening() {
    inner_wall_y = v2_case_d / 2 - v2_wall;

    translate([latch_button_center_x,
               inner_wall_y - epsilon,
               latch_button_bottom_z + latch_button_height / 2])
        rounded_xz_prism(
            latch_button_width + 2 * latch_fit_clearance,
            latch_button_height + 2 * latch_fit_clearance,
            v2_wall + 2 * epsilon,
            latch_button_corner_radius + latch_fit_clearance);
}

module latch_case_fit_openings() {
    // Only the exterior button pierces the shell. The latch body rests fully
    // inside the case on top of the intact base floor.
    latch_button_wall_opening();
}
