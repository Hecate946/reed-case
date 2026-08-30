/* Interactive OpenSCAD entry point.

   Change `view` to inspect the design. Functional dimensions live only in
   config.scad.
*/

mesh_profile = "fine"; // "prototype" or "fine"
view = "v2_seal"; // "v2_open", "v2_closed", "v2_exploded", "v2_closed_front", "v2_base_fit", "v2_seal", "tray", "print_layout"

// Useful views:
// view = "v2_open";
// view = "v2_closed";
// view = "v2_exploded";
// view = "v2_closed_front";
// view = "v2_base_fit";
// view = "v2_seal";
// view = "tray";
// view = "print_layout";

include <config.scad>
include <assembly.scad>

render_selected(view);
