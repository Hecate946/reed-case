/*
  Full-height case-side blocks for future spring/latch development.

  Each side is a sharp-cornered stepped solid with no holes, slots, channels,
  or enclosed cutouts. Both remain callable separately for iteration and are
  also fused into the printable base.
*/

include <../lib/geometry.scad>

module leaf_spring_mount_block(outward_direction = -1) {
    assert(outward_direction == -1 || outward_direction == 1);

    w = leaf_spring_mount_width;
    d = leaf_spring_mount_depth;
    foot_w = leaf_spring_mount_outer_foot_width;
    step_y = d / 2 - leaf_spring_mount_front_step_depth;

    // In Top view the back portion is full width and the front/lower portion
    // is the shorter outward foot. This is one concave footprint extruded to
    // full height, rather than a block with a cavity subtracted from it.
    footprint = outward_direction < 0
        ? [[-w/2, -d/2], [ w/2, -d/2], [ w/2, step_y],
           [-w/2 + foot_w, step_y], [-w/2 + foot_w, d/2],
           [-w/2, d/2]]
        : [[-w/2, -d/2], [ w/2, -d/2], [ w/2, d/2],
           [ w/2 - foot_w, d/2], [ w/2 - foot_w, step_y],
           [-w/2, step_y]];

    linear_extrude(height = leaf_spring_mount_height)
        polygon(footprint);
}

module left_leaf_spring_mount() {
    leaf_spring_mount_block(-1);
}

module right_leaf_spring_mount() {
    leaf_spring_mount_block(1);
}

module installed_leaf_spring_mounts() {
    translate([leaf_spring_mount_centers_x[0],
               leaf_spring_mount_y,
               v2_base_floor_t])
        left_leaf_spring_mount();
    translate([leaf_spring_mount_centers_x[1],
               leaf_spring_mount_y,
               v2_base_floor_t])
        right_leaf_spring_mount();
}
