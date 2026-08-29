/*
  Parametric implementation of the double-sided tray disclosed in
  US12103755B2, particularly Figs. 1-10 and claims 1-16.

  The patent does not disclose millimeter dimensions. The topology below
  follows the disclosure; dimensions are fitted to the configured reed and
  humidity-pack envelopes in config.scad.

  One complete tray = 2 x behn_tray_face + 1 x behn_tray_core.
*/

include <../lib/geometry.scad>
include <../lib/hardware.scad>

function guide_t(i) = i == 0 || i == reeds_per_face
                    ? tray_outer_guide_t
                    : tray_guide_t;
function guide_x(i) = i == 0
                    ? -tray_guide_span / 2
                    : i == reeds_per_face
                    ? tray_guide_span / 2
                    : -tray_guide_span / 2 +
                      reed_slot_clear_w +
                      (tray_outer_guide_t + tray_guide_t) / 2 +
                      (i - 1) * (reed_slot_clear_w + tray_guide_t);
function lane_x(i) = (guide_x(i) + guide_t(i) / 2 +
                      guide_x(i + 1) - guide_t(i + 1) / 2) / 2;
function aperture_column_pitch() = min(tray_air_column_pitch,
                                       reed_slot_clear_w / 3.7);
// The reed heel line, and therefore the tip stop, is now referenced directly
// to the tray edge. The aperture field is derived from those two lines rather
// than the other way round, which is what lets the field run nearly the full
// passage length as it does in the reference photographs.
// The reed is located from the tip border inwards. The border is a wall of
// tray_border_w sitting at the tray edge, matching the two side frames, so
// the tip end reads as the same narrow band they do instead of a wide flat
// lip. Slack collects at the open heel end, which is where you reach in to
// lift a reed out anyway.
function tip_stop_outer_y() = tray_d / 2;
function tip_stop_inner_y() = tip_stop_outer_y() - tray_border_w;
function reed_heel_y() = tip_stop_inner_y() - reed_length - reed_tip_clearance;
function aperture_edge_relief_r() = tray_air_hole_d / 2 +
                                    tray_air_edge_relief;
function aperture_start_y() = -tray_d / 2 + aperture_heel_margin +
                              aperture_edge_relief_r();
function aperture_end_y() = tip_stop_inner_y() - aperture_tip_margin -
                            aperture_edge_relief_r();
function aperture_row_pitch() = (aperture_end_y() - aperture_start_y()) /
                                max(tray_air_rows - 1, 1);
function aperture_y(row) = aperture_start_y() + row * aperture_row_pitch();
function rail_start_y() = aperture_start_y() - aperture_row_pitch() / 2;
function rail_end_y() = (aperture_y(rail_rows - 1) +
                         aperture_y(rail_rows)) / 2;
function reed_plane_front_y() = aperture_start_y() -
                                 tray_air_hole_d / 2 -
                                 tray_air_edge_relief -
                                 tray_reed_plane_edge_margin;
// Digits sit centred on the height of the tip-stop wall.
function lane_number_z() = tray_face_t + tray_guide_h / 2;
function reed_center_y() = (reed_heel_y() + tip_stop_inner_y()) / 2;
function guide_wall_start_y() = guide_walls_full_length
                              ? -tray_d / 2 - epsilon
                              : reed_plane_front_y();
function ventilation_field_half_w() =
    abs(lane_x(0)) +
    (tray_air_columns - 1) / 2 * aperture_column_pitch() +
    (tray_air_hole_d + 2 * tray_air_edge_relief) / 2 +
    tray_pack_vent_clearance;

// If both optional features are switched back on at once, the rails can start
// ahead of the sheet and print as detached islands. The margin is small even
// at the default row count, so fail loudly rather than ship floating rails.
assert(!(stock_rails_enable && front_plane_cutout_enable) ||
       rail_start_y() >= reed_plane_front_y() + 0.50,
       str("Stock rails would begin ", reed_plane_front_y() - rail_start_y(),
           " mm ahead of the reed-facing sheet. Increase tray_air_rows, ",
           "reduce tray_reed_plane_edge_margin, or leave ",
           "front_plane_cutout_enable off."));

module patent_face_outline_2d() {
    // A plain rounded rectangle. The magnet pockets are buried inside the
    // side borders now, so there are no ears protruding past this outline.
    offset(r = tray_body_corner_r)
        square([tray_body_w - 2 * tray_body_corner_r,
                tray_d - 2 * tray_body_corner_r], center = true);
}

module patent_platform(h) {
    linear_extrude(height = h) patent_face_outline_2d();
}

module patent_ventilation_apertures_2d(hole_d = tray_air_hole_d) {
    // Physical tray: 22 rows of three small apertures in each passage.
    for (i = [0 : reeds_per_face - 1],
         row = [0 : tray_air_rows - 1],
         col = [0 : tray_air_columns - 1]) {
        x_offset = (col - (tray_air_columns - 1) / 2) *
                   aperture_column_pitch();
        translate([lane_x(i) + x_offset, aperture_y(row)])
            circle(d = hole_d, $fn = $preview ? 20 : 40);
    }
}

module patent_front_plane_cutout_2d() {
    // Optional. The reference tray edge is solid above and below the humidity
    // pack mouth, so this is disabled by default; set
    // front_plane_cutout_enable = true in config.scad to restore the open
    // insertion end. The outer-frame strips and corner ears stay full length
    // for stiffness either way.
    if (front_plane_cutout_enable) {
        left_inner_x = guide_x(0) + guide_t(0) / 2;
        right_inner_x = guide_x(reeds_per_face) -
                        guide_t(reeds_per_face) / 2;
        front_y = -tray_d / 2 - epsilon;
        back_y = reed_plane_front_y();

        assert(back_y > -tray_d / 2,
               "Reed-plane margin extends beyond the tray outline");

        translate([(left_inner_x + right_inner_x) / 2,
                   (front_y + back_y) / 2])
            square([right_inner_x - left_inner_x,
                    back_y - front_y], center = true);
    }
}

module patent_lane_number_engraving(first_lane = 1) {
    // Engraved passage numbers on the vertical inner face of the reed tip
    // stop, one per passage, reading upright when the open tray is viewed
    // from the heel end.
    //
    // rotate([90, 0, 0]) maps the glyph's own +x onto world +X and its +y
    // onto world +Z, which is what an observer at -Y reads as left-to-right
    // and upright. That same rotation sends the extrusion to -Y, so the
    // block is placed one depth proud of the wall and cuts back into it.
    if (lane_numbers_enable)
        for (i = [0 : reeds_per_face - 1])
            translate([lane_x(i),
                       tip_stop_inner_y() + lane_number_depth,
                       lane_number_z()])
                rotate([90, 0, 0])
                    linear_extrude(height = lane_number_depth + epsilon)
                            text(str(i + first_lane),
                                 size = lane_number_size,
                                 font = lane_number_font,
                                 halign = "center",
                                 valign = "center",
                                 $fn = $preview ? 16 : 32);
}

module patent_perforated_layer(z, h, hole_d) {
    translate([0, 0, z])
        linear_extrude(height = h)
        difference() {
            patent_face_outline_2d();
            patent_ventilation_apertures_2d(hole_d);
            patent_front_plane_cutout_2d();
        }
}

module patent_perforated_platform() {
    // A three-layer micro-chamfer softens the reed-facing aperture rims. This
    // remains a small set of 2D extrusions, avoiding the enormous CSG tree
    // produced by hundreds of individual 3D fillets in OpenSCAD 2021.
    relief_step_h = tray_air_edge_relief_h / tray_air_edge_steps;
    core_h = tray_face_t - tray_air_edge_relief_h;

    union() {
        patent_perforated_layer(0, core_h + epsilon, tray_air_hole_d);
        for (step = [0 : tray_air_edge_steps - 1])
            patent_perforated_layer(
                core_h + step * relief_step_h - epsilon,
                relief_step_h + 2 * epsilon,
                tray_air_hole_d + 2 * tray_air_edge_relief *
                    (step + 1) / tray_air_edge_steps
            );
    }
}

module patent_guide_walls() {
    // In the reference photographs the dividers run the whole length of the
    // tray. They are extruded as one 2D profile intersected with the tray
    // outline, so the ends follow the rounded corners instead of hanging over
    // them, and the whole set is a single cheap extrusion.
    start_y = guide_wall_start_y();
    end_y = tip_stop_inner_y() + epsilon;

    translate([0, 0, tray_face_t])
        linear_extrude(height = tray_guide_h)
            intersection() {
                patent_face_outline_2d();
                union()
                    for (i = [0 : reeds_per_face])
                        translate([guide_x(i), (start_y + end_y) / 2])
                            square([guide_t(i), end_y - start_y],
                                   center = true);
            }
}

module patent_guide_end_runout() {
    // Cutting solid that takes every raised feature down to the floor over
    // the last guide_end_taper millimetres of the open heel end.
    //
    // The profile is a quarter arc that is tangent to the top of the wall
    // inboard and meets the floor VERTICALLY at the tray edge. That leaves a
    // rounded nose. The earlier profile was the other way round - tangent to
    // the floor - which faired out to a feather edge that was both fragile
    // and unprintable. Built as a polygon in (z, y) and swept along X, which
    // is one cheap extrusion for the whole tray.
    //
    // guide_end_taper == tray_guide_h gives a true circular quarter round.
    L = guide_end_taper;
    h = tray_guide_h;
    y0 = -tray_d / 2 - epsilon;
    z0 = tray_face_t;
    z_top = z0 + h + 1.0;
    steps = $preview ? 10 : 24;
    span = tray_w + 20;

    if (L > 0)
        translate([-span / 2, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(height = span)
                    polygon(concat(
                        [[z0 - 1.0, y0 - 1.0], [z_top, y0 - 1.0],
                         [z_top, y0 + L]],
                        [for (s = [steps : -1 : 0])
                            let (u = s / steps)
                            [z0 + h * sqrt(max(1 - (1 - u) * (1 - u), 0)),
                             y0 + L * u]],
                        [[z0 - 1.0, y0]]
                    ));
}

module patent_longitudinal_stock_rails() {
    // Fig. 4 element 152. Two rounded rails per passage, each sitting midway
    // between adjacent aperture columns so it runs tangent to the softened
    // hole rims rather than across them. They begin half a row pitch below
    // the first aperture, at the heel edge, and stop halfway between rows 11
    // and 12 - the 11.5th row - covering exactly half of the 22-row field.
    //
    // The profile is a hull of two flattened spheres, which gives a rounded
    // crown and domed ends in one cheap operation.
    end_radius = rail_w / 2;

    if (stock_rails_enable)
    for (i = [0 : reeds_per_face - 1], side = [-1, 1])
        hull()
            for (y = [rail_start_y() + end_radius,
                      rail_end_y() - end_radius])
                translate([lane_x(i) +
                           side * aperture_column_pitch() / 2,
                           y,
                           tray_face_t])
                    scale([1, 1, rail_h / end_radius])
                        sphere(d = rail_w, $fn = $preview ? 16 : 32);
}

module patent_reed_tip_stop() {
    // The third border. Same construction as the side frames: a plain
    // rectangle of tray_border_w, run out to the tray edge and intersected
    // with the body outline so the two ends pick up the corner radius and
    // meet the side frames in a closed U.
    inner_y = tip_stop_inner_y();

    assert(tray_border_w >= lane_number_depth + 1.0,
           "Tip border is too thin to carry the engraved numbers");

    translate([0, 0, tray_face_t])
        linear_extrude(height = tray_guide_h)
            intersection() {
                patent_face_outline_2d();
                translate([0, inner_y + tray_border_w / 2 + epsilon])
                    square([tray_body_w + 20,
                            tray_border_w + 2 * epsilon], center = true);
            }
}

module patent_outer_side_walls() {
    // Two plain rectangular strips filling the space between the outer guide
    // wall and the edge of the body, trimmed to the body outline so the ends
    // pick up the corner radius. This replaces a hull of four circles: the
    // rounded stadium shape it produced was doing nothing the corner radius
    // was not already doing, and it read as a bulge rather than a border.
    //
    // The magnet pockets are cut into these frames rather than into ears
    // hanging off the outline, so the frame has to be at least
    // tray_magnet_d + 2 * magnet_wall_min wide. config.scad asserts that.
    outer_guide_face = tray_guide_span / 2 + tray_outer_guide_t / 2;
    side_frame_w = tray_body_w / 2 - outer_guide_face;

    assert(side_frame_w > 0,
           "Guide span leaves no room for a side frame");

    translate([0, 0, tray_face_t])
        linear_extrude(height = tray_guide_h)
            intersection() {
                patent_face_outline_2d();
                union()
                    for (x = [-1, 1])
                        translate([x * (outer_guide_face +
                                        side_frame_w / 2), 0])
                            square([side_frame_w,
                                    tray_d + 2 * epsilon], center = true);
            }
}

module patent_magnet_apertures() {
    for (x = [-1, 1], y = [-1, 1])
        translate([x * tray_magnet_x, y * tray_magnet_y,
                   tray_face_t + tray_guide_h -
                   tray_magnet_h - magnet_h_clearance])
            magnet_pocket();
}

function band_groove_r() = elastic_band_d / 2 + elastic_band_clearance;
function band_groove_z() = tray_face_t + tray_guide_h -
                           band_groove_r() - elastic_band_seat_depth;
function band_y(gap) = aperture_y(gap - 1);

module patent_band_notches() {
    // A half-round seat for round elastic cord, swept across the whole tray
    // so every divider, both side borders and the tip border get the same
    // groove and the cord runs dead straight.
    //
    // The groove centre is elastic_band_seat_depth below a plain half-round,
    // so the cord sits about 70% buried and cannot roll off the wall tops,
    // while the mouth stays wider than the cord and needs no undercut.
    //
    // band_y() takes a 1-indexed row gap: 8.5 is between holes 8 and 9,
    // counting apertures from the heel end.
    for (gap = elastic_band_row_gaps) {
        translate([-tray_w / 2 - epsilon, band_y(gap), band_groove_z()])
            rotate([0, 90, 0])
                cylinder(r = band_groove_r(),
                         h = tray_w + 2 * epsilon,
                         $fn = $preview ? 24 : 48);
        // Square off everything above the seat so the mouth is open to the
        // top face instead of leaving a lip the cord has to snap past.
        translate([0, band_y(gap),
                   band_groove_z() + (tray_guide_h + 1) / 2])
            cube([tray_w + 2 * epsilon,
                  2 * band_groove_r(),
                  tray_guide_h + 1], center = true);
    }
}

module patent_pack_stop_half_ribs() {
    // Each face carries half of every longitudinal stop support. The mirrored
    // face supplies the other half, so the assembled tray has full-height ribs
    // without a transverse connector or loose islands in the core print.
    rib_start_y = -tray_d / 2;
    rib_end_y = tray_pack_stop_y;
    rib_length = rib_end_y - rib_start_y;

    // Straight, constant-section stops aligned with the guide walls. Each
    // face supplies half the core height and the halves meet at mid-plane.
    for (i = [1 : reeds_per_face - 1])
        translate([guide_x(i), (rib_start_y + rib_end_y) / 2,
                   -tray_core_h / 4])
            cube([tray_pack_support_w, rib_length,
                  tray_core_h / 2 + epsilon], center = true);
}

module behn_tray_face(first_lane = 1) {
    union() {
        patent_perforated_platform();
        patent_pack_stop_half_ribs();
        difference() {
            union() {
            patent_guide_walls();
            patent_outer_side_walls();
            patent_longitudinal_stock_rails();
            patent_reed_tip_stop();
            }
            patent_guide_end_runout();
            patent_band_notches();
            patent_magnet_apertures();
            patent_lane_number_engraving(first_lane);
        }
    }
}

module behn_tray_core() {
    // The channel is wide enough to expose even the outer edges of the
    // chamfered ventilation holes, not merely wide enough for the pack.
    cavity_w = max(boveda_w + 2 * boveda_clearance,
                   2 * ventilation_field_half_w());
    mouth_round_r = min(tray_pack_mouth_round_r,
                        (tray_body_w - cavity_w) / 2 -
                        tray_body_corner_r - epsilon);

    assert(mouth_round_r >= 0.5,
           "Humidity channel leaves too little wall for a rounded mouth");

    difference() {
        patent_platform(tray_core_h);
        // The central channel is open at both ends. Circular reliefs at each
        // mouth round the exposed inner corners for easier insertion.
        translate([-cavity_w / 2,
                   -tray_d / 2 - epsilon,
                   -epsilon])
            cube([cavity_w,
                  tray_d + 2 * epsilon,
                  tray_core_h + 2 * epsilon]);
        for (x = [-1, 1], y = [-1, 1])
            translate([x * cavity_w / 2,
                       y * tray_d / 2,
                       -epsilon])
                // Clamp the fillet to preserve thin preset walls.
                cylinder(r = mouth_round_r,
                         h = tray_core_h + 2 * epsilon,
                         $fn = $preview ? 24 : 48);
    }
}

// Passages 1..N. Takes the magnets.
module behn_tray_face_a() { behn_tray_face(1); }

// Passages N+1..2N. Takes the steel discs. Same geometry otherwise, so the
// two are one part with one number changed - but they are no longer the same
// STL, and a tray needs one of each.
module behn_tray_face_b() { behn_tray_face(reeds_per_face + 1); }

module behn_tray() {
    color([0.16, 0.18, 0.21]) behn_tray_core();
    color([0.20, 0.22, 0.25])
        translate([0, 0, tray_core_h]) behn_tray_face_a();
    // The lower face is rotated about Y, not mirrored: a reflection is not a
    // physical operation. The rotation keeps the reed-tip end at the tip end
    // and the engraved digits reading correctly from below.
    color([0.20, 0.22, 0.25])
        rotate([0, 180, 0]) behn_tray_face_b();
}

// Backward-compatible aliases for the original preview names.
module reed_plate() { behn_tray_face_a(); }
