/*
  Separate moving front latch.

  One flat plate slides in a shallow pan recessed into the base floor. The
  leaf spring pushes it outward until its full-width front face lands on the
  inner front wall, and that wall is the only locked stop the design needs.
  A single closing tongue rises above the seam; its outward face reads as
  ---\ , a flat crown falling along one straight ramp to a protruding catch
  with a horizontal underside. The lid carries nothing but a plain pocket.

  The latch is never fused to the printable case base, so every feature stays
  independently adjustable.
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

module latch_catch_profile_2d() {
    // Side profile in local (y, z) with z = 0 at the case seam. Read the
    // outward face top-down: flat crown, one straight ramp, then the catch.
    front_y = latch_body_depth / 2 - latch_tongue_front_setback;
    back_y  = -latch_body_depth / 2;
    crest_y = front_y + latch_catch_extension;
    ramp_y  = front_y - latch_catch_ramp_start_inset;

    profile = [
        [back_y,  -latch_catch_root_sink],
        [front_y, -latch_catch_root_sink],
        [front_y,  latch_catch_underside_above_seam],
        [crest_y,  latch_catch_underside_above_seam],
        [crest_y,  latch_catch_crest_top_above_seam],
        [ramp_y,   latch_catch_height],
        [back_y,   latch_catch_height]
    ];

    // Fillet the single concave corner first, then break every convex edge on
    // one consistent radius. This is what makes the catch feel deliberate
    // going in instead of scraping over a sharp corner.
    offset(r =  latch_catch_edge_round)
        offset(r = -latch_catch_edge_round)
            offset(r = -latch_catch_notch_round)
                offset(r =  latch_catch_notch_round)
                    polygon(points = profile);
}

module latch_closing_tongue() {
    seam_z = latch_body_height;
    front_y = latch_body_depth / 2 - latch_tongue_front_setback;
    back_y = -latch_body_depth / 2;
    crest_y = front_y + latch_catch_extension;

    translate([0, 0, seam_z])
        intersection() {
            // Extrude the exact side profile across the tongue width.
            multmatrix([
                [0, 0, 1, -latch_catch_width / 2],
                [1, 0, 0,  0],
                [0, 1, 0,  0],
                [0, 0, 0,  1]
            ])
                linear_extrude(height = latch_catch_width)
                    latch_catch_profile_2d();

            // Plan rounding softens the two visible ends of the tongue.
            translate([0,
                       (back_y + crest_y) / 2,
                       -latch_catch_root_sink - epsilon])
                rounded_prism([latch_catch_width,
                               crest_y - back_y,
                               latch_catch_height +
                                   latch_catch_root_sink + 2 * epsilon],
                              latch_catch_plan_corner_radius);
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
    // The plate sits in the slide pan recessed into the interior floor. It
    // never enters or protrudes through the exterior bottom shell. Positive
    // travel moves it inward (-Y).
    assert(inward_travel >= 0 &&
           inward_travel <= latch_inward_travel + epsilon);
    translate([0,
               latch_body_y - inward_travel,
               latch_body_bottom_z])
        latch_piece();
}

module latch_slide_pan_cut() {
    // Shallow pan in the base floor. Its side walls guide the plate; its rear
    // wall is only an overtravel backstop one relief behind full press.
    translate([-latch_pocket_width / 2,
               latch_pocket_back_y,
               latch_floor_z])
        cube([latch_pocket_width,
              latch_pocket_depth_y,
              latch_floor_pocket_depth + epsilon]);
}

module lid_latch_groove_volume(extra_depth = 0) {
    // Defined in lid print orientation. This is a subtraction/debug volume,
    // never a protruding physical part of the lid.
    inner_y = v2_lid_latch_groove_inner_y;
    outer_y = v2_lid_latch_groove_outer_y + extra_depth;
    r = v2_lid_latch_groove_corner_radius;
    z_lo = v2_lid_h - v2_lid_latch_groove_roof_above_seam;
    z_hi = v2_lid_h - v2_lid_latch_groove_floor_above_seam;

    multmatrix([
        [0, 0, 1, -v2_lid_latch_groove_width / 2],
        [1, 0, 0,  0],
        [0, 1, 0,  0],
        [0, 0, 0,  1]
    ])
        linear_extrude(height = v2_lid_latch_groove_width)
            union() {
                // Rounded pocket body.
                offset(r = r) offset(r = -r)
                    polygon([[inner_y, z_lo], [outer_y, z_lo],
                             [outer_y, z_hi], [inner_y, z_hi]]);
                // Square, full-height mouth at the wall face.
                polygon([[inner_y - r - epsilon, z_lo],
                         [inner_y + r,           z_lo],
                         [inner_y + r,           z_hi],
                         [inner_y - r - epsilon, z_hi]]);
            }
}

module lid_latch_groove_cut() {
    lid_latch_groove_volume();
}

module latch_button_wall_opening() {
    translate([latch_button_center_x,
               latch_wall_inner_y - epsilon,
               latch_button_bottom_z + latch_button_height / 2])
        rounded_xz_prism(
            latch_button_width + 2 * latch_fit_clearance,
            latch_button_height + 2 * latch_fit_clearance,
            v2_wall + 2 * epsilon,
            latch_button_corner_radius + latch_fit_clearance);
}

module latch_case_fit_openings() {
    // The exterior button pierces the shell; the slide pan is recessed into
    // the interior floor. Neither breaks the exterior bottom.
    latch_button_wall_opening();
    latch_slide_pan_cut();
}
