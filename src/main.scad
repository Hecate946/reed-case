/* Interactive OpenSCAD entry point.

   Change `view` to inspect the design. Functional dimensions live only in
   config.scad.
*/

mesh_profile = "fine"; // "prototype" or "fine"
view = "print_layout"; // "case_open", "case_closed", "case_exploded", "case_closed_front", "roller_catch_mechanism", "roller_catch_hardware", "bottom_case", "bottom_case_shell", "humidity_bay_open", "humidity_bay_closed", "tray", "tray_test", "print_layout"

// Useful views:
// view = "case_open";
// view = "case_closed";
// view = "case_exploded";
// view = "case_closed_front";
// view = "roller_catch_mechanism";
// view = "roller_catch_hardware";
// view = "bottom_case";
// view = "bottom_case_shell";
// view = "humidity_bay_open";
// view = "humidity_bay_closed";
// view = "bottom_case_with_trays";
// view = "lid_seal";
// view = "tray";
// view = "tray_test";
// view = "behn_tray";
// view = "behn_tray_test";
// view = "print_layout";

include <config.scad>
include <assembly.scad>

render_selected(view);
