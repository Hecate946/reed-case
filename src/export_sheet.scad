/* 2D metal hardware export entry point. */

sheet_part = is_undef(sheet_part) ? "side_latch_cover" : sheet_part;
mesh_profile = is_undef(mesh_profile) ? "fine" : mesh_profile;

include <config.scad>
include <assembly.scad>

if (sheet_part == "side_latch_cover")
    side_latch_cover_plate_2d();
else if (sheet_part == "side_leaf_spring")
    side_leaf_spring_strip_2d();
else
    assert(false, str("Unknown sheet_part: ", sheet_part));
