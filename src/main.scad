// Interactive entry point. HECATE946 is now the default enclosure preview.
// The original Premium-20 and Size-60 presets remain available.
preset = "hecate946"; // "hecate946", "behn_premium20", "size60_studio"

// HECATE946
// Fit-inspection views (actual Behn trays, not simplified blocks):
// preview_part = "hecate946_nested";
preview_part = "hecate946_nested_exploded";
// preview_part = "hecate946_one_tray_fit";

// Individual / enclosure views:
// preview_part = "hecate946_base";
// preview_part = "hecate946_lid";
// preview_part = "hecate946_hinge_coupon";
// preview_part = "hecate946_seal_view";
// preview_part = "hecate946_layout";
// preview_part = "hecate946_assembly";

// Existing tray / reference shell parts
// preview_part = "behn_tray_face_a";
// preview_part = "behn_tray_face_b";
// preview_part = "reed_plate";
// preview_part = "behn_tray_core";
// preview_part = "behn_tray";
// preview_part = "populated_behn_tray";
// preview_part = "pack_insertion_demo";
// preview_part = "patent_tray_exploded";
// preview_part = "behn_tray_stack";
// preview_part = "base";
// preview_part = "lid";
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
