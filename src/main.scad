/* Interactive OpenSCAD entry point.

   Change `view` to inspect the design. Functional dimensions live only in
   config.scad.
*/

mesh_profile = "fine"; // "prototype" or "fine"
view = "bottom_case_boveda_size_60"; // "latch_groove_lock_detail", "latch_groove_closing_entry", "latch_button_release_detail", "top_lid_latch_groove", "latch_piece", "bottom_case", "bottom_case_boveda_size_60", "bottom_case_shell", "bottom_case_latch_fit", "bottom_case_latch_pressed", "leaf_spring_mount_pair", "left_leaf_spring_mount", "right_leaf_spring_mount", "case_open", "case_closed", "case_exploded", "case_closed_front", "bottom_case_with_trays", "lid_seal", "tray", "print_layout"

// Useful views:
// view = "bottom_case";
// view = "bottom_case_boveda_size_60";
// view = "bottom_case_shell";
// view = "bottom_case_latch_fit";
// view = "bottom_case_latch_pressed";
// view = "latch_piece";
// view = "latch_groove_lock_detail";
// view = "latch_groove_closing_entry";
// view = "latch_button_release_detail";
// view = "top_lid_latch_groove";
// view = "leaf_spring_mount_pair";
// view = "left_leaf_spring_mount";
// view = "right_leaf_spring_mount";
// view = "case_open";
// view = "case_closed";
// view = "case_exploded";
// view = "case_closed_front";
// view = "bottom_case_with_trays";
// view = "lid_seal";
// view = "tray";
// view = "print_layout";

include <config.scad>
include <assembly.scad>

render_selected(view);
