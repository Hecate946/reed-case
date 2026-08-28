/*
  Central configuration.

  VERIFIED PUBLIC BEHN VALUES
  - Premium 20 exterior body: 1.50 x 4.00 x 4.00 in
  - PLA construction, gasket-sealed, perforated/railed trays
  - two magnetically attached 10-reed trays, 72% Boveda per tray

  All other dimensions below are original engineering starting values.
*/

assert(preset == "behn_premium20" || preset == "size60_studio",
       str("Unknown preset: ", preset));

inch = 25.4;
$fn = $preview ? 48 : 96;
epsilon = 0.02;

is_size60 = preset == "size60_studio";

// Hinge dimensions are declared early because the shell body is shortened so
// the external barrel remains inside the requested overall depth envelope.
hinge_outer_d = 5.6;
hinge_pin_d = 1.75;
hinge_pin_clearance = 0.22;
hinge_overlap = 0.70;

// Overall closed shell envelope (hinge included; pin head/latch clip excluded).
case_w = is_size60 ? 151.0 : 4.00 * inch;
case_d = is_size60 ? 124.0 : 4.00 * inch;
case_h = is_size60 ? 48.0 : 1.50 * inch;
base_h = case_h / 2;
lid_h = case_h - base_h;
corner_r = is_size60 ? 9.0 : 7.0;
body_d = case_d - hinge_outer_d + hinge_overlap;
body_y = (case_d - body_d) / 2;

// Shell and printer fit.
wall = 2.4;
floor_t = 2.4;
printer_clearance = 0.25;
elephant_foot_relief = 0.25;

// Airtight seal: 2 mm closed-cell silicone cord is the intended consumable.
gasket_d = 2.0;
gasket_groove_w = 2.35;
gasket_groove_d = 1.30;
gasket_compression = 0.25; // fraction of nominal diameter, target 20-30%
seal_inset = wall + 2.2;
seal_tongue_w = 1.15;
seal_tongue_h = 0.55;

// Humidity pack. Official face sizes; pack thickness is a measured/estimated
// allowance and should be checked against the actual pack before printing.
boveda_w = is_size60 ? 133.35 : 69.85;
boveda_d = is_size60 ? 88.90 : 63.50;
boveda_h = is_size60 ? 8.0 : 4.5;
boveda_clearance = 1.0;

// Reed plates. Four plates total: two per shell half.
plates_per_half = 2;
reeds_per_plate = is_size60 ? 7 : 5;
total_reed_capacity = 2 * plates_per_half * reeds_per_plate;
tray_side_gap = 2.2;
tray_w = case_w - 2 * (wall + tray_side_gap);
tray_d = body_d - 2 * (wall + tray_side_gap);
tray_t = 1.6;
tray_corner_r = 3.0;
tray_boss_h = 5.4; // full-height stack spacer; contains top and bottom magnets
tray_stack_gap = 0.35; // vertical air gap above the tallest reed in a lower plate
tray_air_hole_d = 3.2;
tray_air_hole_pitch = 8.0;

// Bb/Eb clarinet reed design envelope. Measure your own reeds before finalizing.
reed_length = 72.0;
reed_max_w = 14.0;
reed_max_h = 3.25;
reed_end_margin = 6.0;
rail_h = 0.55;
rail_w = 1.10;
rail_positions = [-0.33, 0.0, 0.33]; // fraction of reed length

// Magnets: nominal 6 x 2 mm discs under each tray corner.
tray_magnet_d = 6.0;
tray_magnet_h = 2.0;
magnet_d_clearance = 0.20;
magnet_h_clearance = 0.15;
tray_magnet_x = is_size60 ? 50.0 : tray_w / 2 - 6.0;
tray_magnet_y = is_size60 ? 50.4 : tray_d / 2 - 6.0;

// Hinge. The rear edge of the barrel defines the overall case depth.
hinge_edge_margin = 7.0;
hinge_center_len = case_w * 0.38;
hinge_knuckle_gap = 0.55;

// Optional removable front latch.
latch_w = is_size60 ? 24.0 : 20.0;
latch_t = 2.0;
latch_clearance = 0.30;
latch_lug_depth = 2.2;
latch_lug_h = 2.0;

// Retainer strip: print in TPU 95A or replace with silicone elastic.
retainer_t = 1.15;
retainer_w = 5.0;
retainer_finger_w = min(reed_max_w - 2, tray_w / reeds_per_plate - 3);
retainer_preload = 0.7;

// Visual separation used only in assembly/exploded previews.
exploded_gap = is_size60 ? 18 : 14;

// Feasibility assertions fail early instead of silently producing bad parts.
assert(case_w > boveda_w + 2 * (wall + boveda_clearance),
       "Humidity pack is too wide for this case preset");
assert(body_d > boveda_d + 2 * (wall + boveda_clearance),
       "Humidity pack is too deep for this case preset");
assert(tray_w / reeds_per_plate > reed_max_w + 1.0,
       "Reed lanes are too narrow; reduce reeds_per_plate or grow the case");
assert(gasket_groove_d < wall, "Gasket groove would break through the rim");
assert(tray_boss_h >= tray_t + rail_h + reed_max_h,
       "Tray spacer bosses must protect the reeds from the next stacked plate");
assert(abs(tray_magnet_x) + (tray_magnet_d + 3.0) / 2 <= tray_w / 2,
       "Tray magnet boss exceeds the plate width");
assert(abs(tray_magnet_y) + (tray_magnet_d + 3.0) / 2 <= tray_d / 2,
       "Tray magnet boss exceeds the plate depth");
assert(abs(tray_magnet_x) - (tray_magnet_d + 3.0) / 2 >=
           boveda_w / 2 + boveda_clearance ||
       abs(tray_magnet_y) - (tray_magnet_d + 3.0) / 2 >=
           boveda_d / 2 + boveda_clearance,
       "Tray magnet tower overlaps the humidity pack allowance");

// Check the actual internal vertical stack for each half.
stack_top = floor_t + boveda_h + 0.20
          + (plates_per_half - 1) *
            (tray_t + rail_h + reed_max_h + tray_stack_gap)
          + max(tray_boss_h, tray_t + rail_h + reed_max_h);
assert(stack_top <= base_h,
       str("Internal stack is ", stack_top - base_h,
           " mm too tall for one shell half"));
