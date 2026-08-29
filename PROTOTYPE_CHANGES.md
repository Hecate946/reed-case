# Prototype tray changes

This revision is aimed at printing **one tray first**.

- Default OpenSCAD preview/export target is one assembled tray, not the case.
- `make stl` exports only one tray's physical pieces: face A, face B, core.
- Removed the redundant outer reed divider on both sides. The left/right structural edge wall now directly bounds the outer reed passage.
- Tray body width is now 88.7 mm instead of 91.9 mm on `behn_premium20`, saving 1.6 mm per side while preserving 14.30 mm clear width in every reed slot.
- Boveda Size 8 opening remains 71.85 mm wide x 5.10 mm high.
- Both silicone O-ring grooves remain at the same height.
- 2.0 mm round silicone is the intended retention material; 60 mm ID is the first O-ring size to try.
- Magnet/steel decision is deferred; both faces use identical hardware pockets.
- Hardware pocket is 4.20 mm straight diameter x 2.15 mm depth for nominal 4 x 2 mm discs.
- Added 0.15 mm pocket lead-in chamfer.
- Added small top-edge softening to the reed platform and raised guide/frame walls.
- Kept the rounded heel-side guide runout and softened ventilation rims.
- Added a 2.0 mm heel bridge to the tray core so the core is one connected U-shaped print instead of two loose side rails.
- Left the outer shell/gasket out of this prototype pass; it still needs a dedicated closure/seal redesign before final printing.
- Corrected stale 6 x 2 mm magnet documentation.
- Polarity instructions were intentionally removed from the prototype workflow; decide that after the physical fit test.

- Reversed the heel-end quarter-round curvature so each divider/side wall rises smoothly out of the reed plane instead of forming the previous rounded-nose profile.
## 2026-08-29 — Symmetric Boveda-core mouth

- Rebuilt the open ends of the Behn tray core as true semicircular/pill caps.
- The inner and outer sides of each core rail now use the same radius, so each
  end reads as `()` instead of a convex outside corner with a concave bite.
- Boveda channel width, core height, heel bridge, and tray fit are unchanged.

