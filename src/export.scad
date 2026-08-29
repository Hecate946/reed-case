// CLI entry point. With no -D part=..., exports/previews one assembled tray.
// `make stl` exports the three support-friendly physical pieces for one tray.
// Examples:
// openscad -o build/base.stl -D 'part="base"' src/export.scad
// openscad -o build/base.stl -D 'preset="size60_studio"' -D 'part="base"' src/export.scad

preset = is_undef(preset) ? "behn_premium20" : preset;
part = is_undef(part) ? "behn_tray" : part;

include <config.scad>
include <assembly.scad>

render_selected(part);

