// CLI entry point. Examples:
// openscad -o build/base.stl -D 'part="base"' src/export.scad
// openscad -o build/base.stl -D 'preset="size60_studio"' -D 'part="base"' src/export.scad

preset = is_undef(preset) ? "behn_premium20" : preset;
part = is_undef(part) ? "assembly" : part;

include <config.scad>
include <assembly.scad>

render_selected(part);

