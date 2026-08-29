# Development workflow

## Fast edit-preview loop

1. Open `src/main.scad`.
2. Use F5 for a fast preview while adjusting values in `src/config.scad`.
3. Use F6 only when you need the fully rendered solid.
4. Switch `preview_part` to `behn_tray_face_a`, `behn_tray_face_b`, `behn_tray_core`,
   `patent_tray_exploded`, `gasket_coupon`, or `tolerance_coupon` while tuning
   fits so preview/render time stays short.
5. Run `make check` after structural edits.
6. Run `make stl` only when a revision is ready to slice.

## Suggested Git rhythm

Commit parameter experiments separately from geometry changes:

```bash
git add src/config.scad
git commit -m "Tune gasket compression for printer"
```

Tag physical prototypes in both Git and on the printed part:

```bash
git tag prototype-v0.1
```

Record filament, slicer profile, magnet fit, gasket result, and leak result in
your commit or issue. A parameter without its physical test result is hard to
reproduce later.

## Good first changes

- Measure your actual Bb/A reeds and update `reed_length`, `reed_max_w`, and
  `reed_max_h`; the patent supplies no millimeter dimensions.
- Measure hydrated and nearly depleted Boveda pack thickness.
- Tune magnet bore clearance with the coupon.
- Tune gasket compression with the coupon before printing a full lid.
- Decide whether your final premium material is PLA, PETG, ASA, or a sealed
  engineering filament. Material changes require new tolerance coupons.
