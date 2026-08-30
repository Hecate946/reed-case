/* CLI export entry point. Prefer the Makefile commands in the project root. */

part = is_undef(part) ? "case_open" : part;

include <config.scad>
include <assembly.scad>

render_selected(part);
