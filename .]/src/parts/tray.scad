/*
  Parametric implementation of the double-sided tray disclosed in
  US12103755B2, particularly Figs. 1-10 and claims 1-16.

  The patent does not disclose millimeter dimensions. The topology below
  follows the disclosure; dimensions are fitted to the configured reed and
  humidity-pack envelopes in config.scad.

  One complete tray is modeled from two reed faces and one core. The three
  support-free components are the intended prototype print workflow.
*/

include <../lib/geometry.scad>
include <../lib/hardware.scad>

// i=0 and i=reeds_per_face are virtual passage boundaries supplied by the
// structural side borders, not separate divider walls. Only indices 1..N-1
// have a physical 1.10 mm guide. This removes the redundant outer divider on
// each side and moves the edge wall inward by exactly its former thickness.
function guide_t(i) = i == 0 || i == reeds_per_face ? 0 : tray_guide_t;
function guide_x(i) = i == 0
                    ? -tray_passage_field_w / 2
                    : i == reeds_per_face
                    ? tray_passage_field_w / 2
                    : -tray_passage_field_w / 2 +
                      i * reed_slot_clear_w +
                      (i - 0.5) * tray_guide_t;
function lane_x(i) = -tray_passage_field_w / 2 +
                     reed_slot_clear_w / 2 +
                     i * (reed_slot_clear_w + tray_guide_t);
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
            circle(d = hole_d, $fn = is_fast_mesh ? 8 : ($preview ? 16 : 24));
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
    if (lane_numbers_enable && !is_fast_mesh)
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
                                 $fn = is_fast_mesh ? 16 : ($preview ? 16 : 32));
}

module patent_perforated_layer(z, h, hole_d, outline_inset = 0) {
    // Keep the perforations as ordinary 2D boolean holes before extrusion.
    // This is substantially faster and more reliable in OpenSCAD 2021 than
    // encoding hundreds of hole loops into one giant polygon path.  It also
    // produces a normal slicer-friendly manifold instead of spending minutes
    // in CGAL triangulation during each STL export.
    translate([0, 0, z])
        linear_extrude(height = h, convexity = 10)
            difference() {
                offset(delta = -outline_inset) patent_face_outline_2d();
                patent_ventilation_apertures_2d(hole_d);
                patent_front_plane_cutout_2d();
            }
}

module patent_perforated_platform() {
    // Production keeps the tiny stepped relief around every ventilation hole.
    // A 0.18 mm rim relief is below what a typical 0.4 mm-nozzle FDM printer
    // can reproduce consistently. Prototype meshes therefore export the same
    // 1.60 mm functional holes as one flat sheet; fine meshes retain the
    // cosmetic edge relief.
    if (is_fast_mesh) {
        patent_perforated_layer(0, tray_face_t, tray_air_hole_d, 0);
    } else {
        relief_step_h = tray_air_edge_relief_h / tray_air_edge_steps;
        core_h = tray_face_t - tray_air_edge_relief_h;

        union() {
            patent_perforated_layer(0, core_h + epsilon, tray_air_hole_d, 0);
            for (step = [0 : tray_air_edge_steps - 1])
                patent_perforated_layer(
                    core_h + step * relief_step_h - epsilon,
                    relief_step_h + 2 * epsilon,
                    tray_air_hole_d + 2 * tray_air_edge_relief *
                        (step + 1) / tray_air_edge_steps,
                    tray_platform_top_chamfer *
                        (step + 1) / tray_air_edge_steps
                );
        }
    }
}

module patent_guide_walls() {
    // In the reference photographs the dividers run the whole length of the
    // tray. They are extruded as one 2D profile intersected with the tray
    // outline, so the ends follow the rounded corners instead of hanging over
    // them, and the whole set is a single cheap extrusion.
    start_y = guide_wall_start_y();
    end_y = tip_stop_inner_y() + epsilon;

    translate([0, 0, tray_face_t - tray_feature_fuse_overlap])
        union()
            // The side borders are the outer walls; only make the N-1
            // dividers that actually separate adjacent reed passages.
            for (i = [1 : reeds_per_face - 1])
                intersection() {
                    linear_extrude(height = tray_guide_h + tray_feature_fuse_overlap)
                        patent_face_outline_2d();
                    top_chamfered_extrude(tray_guide_h + tray_feature_fuse_overlap,
                                          tray_wall_top_chamfer)
                        translate([guide_x(i), (start_y + end_y) / 2])
                            square([guide_t(i), end_y - start_y],
                                   center = true);
                }
}

module patent_guide_end_runout() {
    // Cutting solid that takes every raised feature down to the floor over
    // the last guide_end_taper millimetres of the open heel end.
    //
    // The quarter-round is intentionally oriented so the visible profile is
    // tangent to the FLOOR at the open heel and turns upward into the full
    // wall inboard. This is the opposite curvature from the previous
    // prototype: instead of looking like a rounded nose dropping into the
    // opening, the wall now rises smoothly out of the reed plane.
    //
    // guide_end_taper == tray_guide_h gives a true circular quarter round.
    L = guide_end_taper;
    h = tray_guide_h;
    y0 = -tray_d / 2 - epsilon;
    z0 = tray_face_t;
    z_top = z0 + h + 1.0;
    steps = is_fast_mesh ? 8 : ($preview ? 10 : 24);
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
                            [z0 + h * (1 - sqrt(max(1 - u * u, 0))),
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
                        sphere(d = rail_w, $fn = is_fast_mesh ? 12 : ($preview ? 16 : 32));
}

module patent_reed_tip_stop() {
    // The third border. Same construction as the side frames: a plain
    // rectangle of tray_border_w, run out to the tray edge and intersected
    // with the body outline so the two ends pick up the corner radius and
    // meet the side frames in a closed U.
    inner_y = tip_stop_inner_y();

    assert(tray_border_w >= lane_number_depth + 1.0,
           "Tip border is too thin to carry the engraved numbers");

    translate([0, 0, tray_face_t - tray_feature_fuse_overlap])
        intersection() {
            linear_extrude(height = tray_guide_h + tray_feature_fuse_overlap)
                patent_face_outline_2d();
            top_chamfered_extrude(tray_guide_h + tray_feature_fuse_overlap,
                                  tray_wall_top_chamfer)
                translate([0, inner_y + tray_border_w / 2 + epsilon])
                    square([tray_body_w + 20,
                            tray_border_w + 2 * epsilon], center = true);
        }
}

module patent_outer_side_walls() {
    // The structural side frames now ARE the outer walls of lanes 1 and N.
    // Their inner faces sit exactly where the inner faces of the old outer
    // divider walls sat. That removes one redundant 1.60 mm wall per side
    // while preserving lane width, magnet protection and the rounded outline.
    passage_edge = tray_passage_field_w / 2;
    side_frame_w = tray_body_w / 2 - passage_edge;

    assert(side_frame_w > 0,
           "Passage field leaves no room for a side frame");

    translate([0, 0, tray_face_t - tray_feature_fuse_overlap])
        union()
            for (x = [-1, 1])
                intersection() {
                    linear_extrude(height = tray_guide_h + tray_feature_fuse_overlap)
                        patent_face_outline_2d();
                    top_chamfered_extrude(tray_guide_h + tray_feature_fuse_overlap,
                                          tray_wall_top_chamfer)
                        translate([x * (passage_edge +
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
                         $fn = is_fast_mesh ? 20 : ($preview ? 24 : 48));
        // Square off everything above the seat so the mouth is open to the
        // top face instead of leaving a lip the cord has to snap past.
        translate([0, band_y(gap),
                   band_groove_z() + (tray_guide_h + 1) / 2])
            cube([tray_w + 2 * epsilon,
                  2 * band_groove_r(),
                  tray_guide_h + 1], center = true);
    }
}

module patent_pack_stop_ribs() {
    // Full-height humidity-pack stop ribs live in the CENTER CORE, not on the
    // printable reed faces. This is deliberately a printability feature:
    // face A and face B now have completely flat backs at Z=0 and can be
    // printed reed-side-up directly on the build plate with no supports.
    //
    // The ribs start at the heel bridge, so they are fused to the U-shaped
    // core and cannot become loose islands. Their final volume is identical
    // to the two old half-ribs after assembly; it is simply assigned to the
    // support-friendly part instead.
    rib_start_y = -tray_d / 2;
    rib_end_y = tray_pack_stop_y;
    rib_length = rib_end_y - rib_start_y;

    for (i = [1 : reeds_per_face - 1])
        translate([guide_x(i), (rib_start_y + rib_end_y) / 2,
                   tray_core_h / 2])
            cube([tray_pack_support_w, rib_length,
                  tray_core_h], center = true);
}

module behn_tray_face(first_lane = 1) {
    union() {
        patent_perforated_platform();
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
    side_rail_w = (tray_body_w - cavity_w) / 2;
    mouth_cap_r = side_rail_w / 2;
    cavity_start_y = -tray_d / 2 + tray_core_heel_bridge_d;
    cap_center_y = tray_d / 2 - mouth_cap_r;

    assert(side_rail_w >= tray_core_side_wall_min,
           "Humidity channel leaves too little material in the core side rails");
    assert(cap_center_y > cavity_start_y,
           "Core is too short for a semicircular humidity-pack mouth cap");

    // Build the core positively as a U-frame instead of subtracting circular
    // bites from a rectangular frame.  Each open leg therefore terminates in
    // a TRUE SEMICIRCULAR CAP: the outer and inner edges have the same radius
    // and flow continuously into one another, like ().  This avoids the old
    // concave 'bite taken out of the corner' appearance at the pack mouth.
    union() {
        linear_extrude(height = tray_core_h, convexity = 10)
            intersection() {
                patent_face_outline_2d();
                union() {
                // Narrow heel bridge keeps the core one connected print.
                translate([0,
                           -tray_d / 2 + tray_core_heel_bridge_d / 2])
                    square([tray_body_w,
                            tray_core_heel_bridge_d], center = true);

                // Two straight rails with pill/semicircular open ends.
                for (side = [-1, 1]) {
                    rail_x = side * (cavity_w / 2 + side_rail_w / 2);

                    // Straight portion; overlaps the heel bridge slightly so
                    // the exported STL is unequivocally one fused solid.
                    translate([rail_x,
                               (cavity_start_y + cap_center_y) / 2])
                        square([side_rail_w,
                                cap_center_y - cavity_start_y + 2 * epsilon],
                               center = true);

                    // Equal-radius cap on both sides of the rail end.
                    translate([rail_x, cap_center_y])
                        circle(r = mouth_cap_r,
                               $fn = is_fast_mesh ? 32 : ($preview ? 32 : 64));
                }
                }
            }

        // The full-height pack-stop ribs are part of this flat-printing core.
        patent_pack_stop_ribs();
    }
}

// Passages 1..N. Hardware pockets are identical to face B.
module behn_tray_face_a() { behn_tray_face(1); }

// Passages N+1..2N. Geometry matches face A except for numbering; the final
// magnet/steel assignment is intentionally not encoded in the printed part.
module behn_tray_face_b() { behn_tray_face(reeds_per_face + 1); }


module behn_tray() {
    color([0.94, 0.94, 0.92]) behn_tray_core();
    color([0.98, 0.98, 0.96])
        translate([0, 0, tray_core_h]) behn_tray_face_a();
    // The lower face is rotated about Y, not mirrored: a reflection is not a
    // physical operation. The rotation keeps the reed-tip end at the tip end
    // and the engraved digits reading correctly from below.
    color([0.98, 0.98, 0.96])
        rotate([0, 180, 0]) behn_tray_face_b();
}


// New-cartridge lane dividers are intentionally heavier than the archived
// Behn reference geometry. The extra section makes the long open frame more
// resistant to twist and gives the snap-in O-ring seats more material.
function tray_divider_t_open() = 1.40;
function tray_guide_t_open(i) =
    i == 0 || i == tray_reeds_per_face ? 0 : tray_divider_t_open();
function tray_passage_field_w_open() =
    tray_reeds_per_face * reed_slot_clear_w +
    (tray_reeds_per_face - 1) * tray_divider_t_open();
function tray_guide_x_open(i) =
    i == 0
        ? -tray_passage_field_w_open() / 2
        : i == tray_reeds_per_face
        ? tray_passage_field_w_open() / 2
        : -tray_passage_field_w_open() / 2 +
          i * reed_slot_clear_w +
          (i - 0.5) * tray_divider_t_open();
function tray_lane_x_open(i) =
    -tray_passage_field_w_open() / 2 +
    reed_slot_clear_w / 2 +
    i * (reed_slot_clear_w + tray_divider_t_open());

function tray_border_w_open() = 6.20; // slightly heavier three-sided protective frame
function tray_body_w_open() = tray_passage_field_w_open() + 2 * tray_border_w_open();
function tray_body_corner_r_open() = min(tray_corner_r,
                                         max(tray_border_w_open() - 0.50,
                                             0.50));
function tray_d_open() = 80.00;
// The new cartridge is only two mirrored shell halves. There is no center
// humidity/core layer. Each shell backing is a little thicker so the two
// halves form a rigid spine when fused back-to-back.
function tray_face_t_open() = 1.65;
function tray_face_join_overlap_open() = 0.12;
function tray_texture_h_open() = 0.38;
function tray_total_h_open() =
    2 * (tray_face_t_open() + tray_guide_h) -
    tray_face_join_overlap_open();
function tray_tip_stop_inner_y_open() = tray_d_open() / 2 - tray_border_w_open();
function tray_slot_start_y_open() = -tray_d_open() / 2;
function tray_slot_end_y_open() = tray_tip_stop_inner_y_open();
function tray_reed_center_y_open() =
    (tray_slot_start_y_open() + tray_slot_end_y_open()) / 2;
function tray_reed_heel_y_open() = tray_reed_center_y_open() - reed_length / 2;
function tray_support_split_y() = tray_reed_heel_y_open() + reed_length * 0.65;
// Two independent retention O-rings cross the cartridge at 40% and 50%
// of the reed length, measured from the heel. Both are inside the 65% support
// zone so they always press the reed onto the breathing runners rather than
// onto the suspended tip region.
tray_o_ring_fractions_open = [0.40, 0.50];
function tray_o_ring_y_open(fraction) =
    tray_reed_heel_y_open() + reed_length * fraction;
function tray_o_ring_cord_r_open() = elastic_band_d / 2;
// Each guide wall gets a keyhole-style snap seat. The 2.0 mm silicone cord is
// pressed through a slightly narrower 1.75 mm throat into a relaxed 2.24 mm
// round pocket. This keeps every lane segment independently captured instead
// of letting one loose span wander along the full tray width.
function tray_o_ring_snap_r_open() = tray_o_ring_cord_r_open() + 0.12;
function tray_o_ring_throat_w_open() = elastic_band_d * 0.875;
function tray_o_ring_snap_center_z_open() =
    tray_face_t_open() + tray_guide_h - 1.35;
function tray_o_ring_wall_top_z_open() = tray_face_t_open() + tray_guide_h;
function tray_lane_window_start_y() = tray_support_split_y() - epsilon;
function tray_lane_window_end_y() = tray_tip_stop_inner_y_open() + epsilon;
function tray_guide_wall_start_y_open() = tray_slot_start_y_open() - epsilon;
function tray_open_magnet_outer_wall() = 1.20;
function tray_open_magnet_pocket_r() =
    (tray_magnet_d + magnet_d_clearance + 2 * magnet_entry_chamfer) / 2;
function tray_magnet_x_open() = tray_body_w_open() / 2 -
                                tray_open_magnet_outer_wall() -
                                tray_open_magnet_pocket_r();
function tray_magnet_y_open() = tray_d_open() / 2 - 9.50;

module tray_face_outline_2d() {
    offset(r = tray_body_corner_r_open())
        square([tray_body_w_open() - 2 * tray_body_corner_r_open(),
                tray_d_open() - 2 * tray_body_corner_r_open()], center = true);
}

module tray_open_tip_windows_2d() {
    for (i = [0 : tray_reeds_per_face - 1])
        translate([tray_lane_x_open(i),
                   (tray_lane_window_start_y() +
                    tray_lane_window_end_y()) / 2])
            square([reed_slot_clear_w,
                    tray_lane_window_end_y() -
                    tray_lane_window_start_y()], center = true);
}

module tray_face_plane() {
    linear_extrude(height = tray_face_t_open(), convexity = 10)
        difference() {
            tray_face_outline_2d();
            tray_open_tip_windows_2d();
        }
}

module tray_guide_walls() {
    start_y = tray_guide_wall_start_y_open();
    end_y = tray_tip_stop_inner_y_open() + epsilon;

    translate([0, 0, tray_face_t_open() - tray_feature_fuse_overlap])
        union() {
            for (i = [1 : tray_reeds_per_face - 1])
                intersection() {
                    linear_extrude(height = tray_guide_h + tray_feature_fuse_overlap)
                        tray_face_outline_2d();
                    top_chamfered_extrude(tray_guide_h + tray_feature_fuse_overlap,
                                          tray_wall_top_chamfer)
                        translate([tray_guide_x_open(i), (start_y + end_y) / 2])
                            square([tray_guide_t_open(i), end_y - start_y], center = true);
                }
        }
}

module tray_outer_side_walls() {
    passage_edge = tray_passage_field_w_open() / 2;
    side_frame_w = tray_body_w_open() / 2 - passage_edge;

    translate([0, 0, tray_face_t_open() - tray_feature_fuse_overlap])
        union() {
            for (x = [-1, 1])
                intersection() {
                    linear_extrude(height = tray_guide_h + tray_feature_fuse_overlap)
                        tray_face_outline_2d();
                    top_chamfered_extrude(tray_guide_h + tray_feature_fuse_overlap,
                                          tray_wall_top_chamfer)
                        translate([x * (passage_edge + side_frame_w / 2), 0])
                            square([side_frame_w,
                                    tray_d_open() + 2 * epsilon], center = true);
                }
        }
}

module tray_reed_tip_stop() {
    inner_y = tray_tip_stop_inner_y_open();

    translate([0, 0, tray_face_t_open() - tray_feature_fuse_overlap])
        intersection() {
            linear_extrude(height = tray_guide_h + tray_feature_fuse_overlap)
                tray_face_outline_2d();
            top_chamfered_extrude(tray_guide_h + tray_feature_fuse_overlap,
                                  tray_wall_top_chamfer)
                translate([0, inner_y + tray_border_w_open() / 2 + epsilon])
                    square([tray_body_w_open() + 20,
                            tray_border_w_open() + 2 * epsilon], center = true);
        }
}

module tray_magnet_apertures() {
    for (x = [-1, 1], y = [-1, 1])
        translate([x * tray_magnet_x_open(),
                   y * tray_magnet_y_open(),
                   tray_face_t_open() + tray_guide_h -
                   tray_magnet_h - magnet_h_clearance])
            magnet_pocket();
}

module tray_lane_number_engraving(first_lane = 1) {
    // Put the reed numbers on the horizontal TOP of the tip-protection bar,
    // rather than on its inner vertical face. Each physical face carries its
    // own numbering, so 1-10 and 11-20 follow the tray when it is flipped.
    if (lane_numbers_enable && !is_fast_mesh)
        for (i = [0 : tray_reeds_per_face - 1])
            translate([tray_lane_x_open(i),
                       tray_tip_stop_inner_y_open() +
                           tray_border_w_open() / 2,
                       tray_face_t_open() + tray_guide_h - lane_number_depth])
                linear_extrude(height = lane_number_depth + epsilon)
                    text(str(i + first_lane),
                         size = lane_number_size,
                         font = lane_number_font,
                         halign = "center",
                         valign = "center",
                         $fn = is_fast_mesh ? 16 : ($preview ? 16 : 32));
}

module tray_breathing_texture() {
    // Five low, longitudinal runners create four continuous air channels
    // beneath each reed. Their elliptical crowns present a smooth tangent
    // surface in the insertion direction, so a reed slides on easily instead
    // of catching on sharp ribs. The channels are open at the heel and empty
    // into the fully-open tip zone, giving moisture a direct breathing path.
    runner_w = 1.90;
    runner_h = tray_texture_h_open();
    runner_pitch = 2.30;
    runner_offsets = [for (k = [-2 : 2]) k * runner_pitch];
    runner_start_y = tray_slot_start_y_open();
    runner_end_y = tray_support_split_y();
    end_r = runner_w / 2;

    for (i = [0 : tray_reeds_per_face - 1], x_off = runner_offsets)
        hull()
            for (y = [runner_start_y + end_r,
                      runner_end_y - end_r])
                translate([tray_lane_x_open(i) + x_off,
                           y,
                           tray_face_t_open()])
                    scale([1, 1, runner_h / end_r])
                        sphere(d = runner_w,
                               $fn = is_fast_mesh ? 14 :
                                     ($preview ? 20 : 36));
}

module tray_o_ring_snap_notch(x_center, cut_w, y) {
    // Keyhole cross-section in Y/Z, extruded through the wall in X. The round
    // lower pocket carries the cord; the narrower vertical throat is what
    // makes installation a deliberate push-down snap like the reference tray.
    r = tray_o_ring_snap_r_open();
    throat_w = tray_o_ring_throat_w_open();
    zc = tray_o_ring_snap_center_z_open();
    z_top = tray_o_ring_wall_top_z_open() + epsilon;

    // Relaxed round seat.
    translate([x_center - cut_w / 2 - epsilon, y, zc])
        rotate([0, 90, 0])
            cylinder(r = r,
                     h = cut_w + 2 * epsilon,
                     $fn = is_fast_mesh ? 20 : ($preview ? 32 : 56));

    // Narrow mouth from the top down into the round seat. Because this mouth
    // is smaller than the cord diameter, silicone deforms as it is pressed in
    // and then expands into the pocket below.
    neck_bottom_z = zc + r * 0.55;
    translate([x_center, y, (neck_bottom_z + z_top) / 2])
        cube([cut_w + 2 * epsilon,
              throat_w,
              z_top - neck_bottom_z + 2 * epsilon], center = true);
}

module tray_o_ring_snap_slots_face() {
    passage_edge = tray_passage_field_w_open() / 2;
    side_frame_w = tray_body_w_open() / 2 - passage_edge;
    side_x = passage_edge + side_frame_w / 2;

    for (fraction = tray_o_ring_fractions_open) {
        y = tray_o_ring_y_open(fraction);

        // The N-1 divider slots turn each span across one reed into its own
        // captured tension segment.
        for (i = [1 : tray_reeds_per_face - 1])
            tray_o_ring_snap_notch(tray_guide_x_open(i),
                                   tray_guide_t_open(i), y);

        // Matching snap seats through the thicker outer rails connect the
        // lane segments to the wraparound channels on both tray edges.
        for (side = [-1, 1])
            tray_o_ring_snap_notch(side * side_x, side_frame_w, y);
    }
}

module tray_o_ring_side_wrap_grooves_face() {
    // Exterior half-round channels route each O-ring from the top snap seats
    // around the cartridge edge to the matching seats on the opposite face.
    // There are two completely separate loops: 40% and 50% of reed length.
    r = tray_o_ring_snap_r_open();
    for (fraction = tray_o_ring_fractions_open) {
        y = tray_o_ring_y_open(fraction);
        for (side = [-1, 1])
            translate([side * tray_body_w_open() / 2,
                       y,
                       -epsilon])
                cylinder(r = r,
                         h = tray_face_t_open() + tray_guide_h + 2 * epsilon,
                         $fn = is_fast_mesh ? 20 : ($preview ? 32 : 56));
    }
}

module tray_face(first_lane = 1) {
    difference() {
        union() {
            tray_face_plane();
            tray_guide_walls();
            tray_outer_side_walls();
            tray_reed_tip_stop();
            tray_breathing_texture();
        }
        tray_magnet_apertures();
        tray_lane_number_engraving(first_lane);
        tray_o_ring_snap_slots_face();
        tray_o_ring_side_wrap_grooves_face();
    }
}

module tray_face_a() { tray_face(1); }
module tray_face_b() { tray_face(tray_reeds_per_face + 1); }

module tray() {
    // The two shell halves are directly fused back-to-back with a small
    // overlap. This removes the old middle layer while avoiding a fragile
    // coplanar-only seam in the exported STL.
    join = tray_face_join_overlap_open();
    union() {
        color([0.97, 0.97, 0.95])
            translate([0, 0, -join / 2])
                tray_face_a();
        color([0.97, 0.97, 0.95])
            translate([0, 0, join / 2])
                rotate([0, 180, 0])
                    tray_face_b();
    }
}

// Keep the original Behn-style reference geometry directly accessible.
module behn_tray_face_a_public() { behn_tray_face_a(); }
module behn_tray_face_b_public() { behn_tray_face_b(); }
module behn_tray_core_public() { behn_tray_core(); }
module behn_tray_public() { behn_tray(); }
