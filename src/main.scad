// Interactive entry point. The default view is ONE complete prototype tray.
// Edit the preset, then leave exactly one preview option below uncommented.
// Saving the file refreshes OpenSCAD automatically.
preset = "behn_premium20"; // "behn_premium20" or "size60_studio"

// preview_part = "base";
// preview_part = "lid";
// preview_part = "behn_tray_face_a";
// preview_part = "behn_tray_face_b";
// preview_part = "reed_plate"; // alias for behn_tray_face_a
// preview_part = "behn_tray_core";
preview_part = "behn_tray";
// preview_part = "populated_behn_tray";
// preview_part = "pack_insertion_demo";
// preview_part = "patent_tray_exploded";
// preview_part = "behn_tray_stack";
// preview_part = "hinge_pin";
// preview_part = "latch_clip";
// preview_part = "gasket_coupon";
// preview_part = "tolerance_coupon";
// preview_part = "print_layout";
// preview_part = "exploded";
// preview_part = "assembly";

include <config.scad>
include <assembly.scad>

render_selected(preview_part);
