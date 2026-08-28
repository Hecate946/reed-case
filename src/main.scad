// Interactive entry point. Edit these two values, then preview with F5/F6.
preset = "behn_premium20"; // "behn_premium20" or "size60_studio"
preview_part = "base"; // base, lid, reed_plate, retainer_strip, assembly
                           // hinge_pin, latch_clip, gasket_coupon,
                           // tolerance_coupon, print_layout, assembly

include <config.scad>
include <assembly.scad>

render_selected(preview_part);

