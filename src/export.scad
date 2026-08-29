// CLI entry point. With no -D part=..., exports/previews one assembled tray.
// `make stl-tray` exports one permanently fused library-ready tray STL.
// Examples:
// openscad -o build/base.stl -D 'part="base"' src/export.scad
// openscad -o build/base.stl -D 'preset="size60_studio"' -D 'part="base"' src/export.scad

preset = is_undef(preset) ? "hecate946" : preset;
part = is_undef(part) ? "hecate946_assembly" : part;

include <config.scad>
include <assembly.scad>

render_selected(part);

