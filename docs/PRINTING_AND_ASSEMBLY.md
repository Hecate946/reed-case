# Printing and assembly

## 1. Calibrate before the full print

1. Export and print `tolerance_coupon.stl` using the intended shell profile.
2. Dry-fit a 6 x 2 mm magnet into every labeled-clearance hole. The script
   produces four graduated bores from 0.10 to 0.40 mm diametral clearance.
3. Print `gasket_coupon.stl`, insert 2 mm silicone cord, and clamp two coupons
   face-to-face. Look for even contact without crushing the cord flat.
4. Put your actual reed and humidity pack on a printed tray face/core or 1:1
   paper outline before committing to both shells.

## 2. Print orientation

- Base and lid: outside face on the bed, cup opening upward.
- Tray face: platform on the bed, guide walls and rails upward.
- Tray core: either broad face on the bed.
- Hinge pin: vertical gives the best roundness, but a metal rod is stronger.
- Latch clip: front face on the bed; use a brim if needed.

Avoid supports inside the gasket groove. If your printer bridges the hinge
poorly, use a small local support blocker/painted support just under the hinge.

## 3. Dry assembly

1. Deburr the hinge bores by hand. Do not aggressively drill them oversize.
2. Align the base's two outer knuckles with the lid's center knuckle.
3. Insert the hinge pin. The lid should rotate freely without radial slop.
4. Verify the case rims meet evenly before adding magnets or gasket.
5. Test the latch clip. Increase `latch_clearance` if it requires force.

## 4. Assemble the patented-layout trays

1. Each complete tray uses two identical faces and one central core.
2. Dry-align the flat back of one face to each broad side of the core. The
   curved finger indents must align with the core's humidity-pack slot.
3. Bond or mechanically fasten the faces to the core without obstructing any
   ventilation aperture or the pack slot.
4. Mark every magnet's north face before adhesive is opened. Opposing tray
   faces must attract when the two completed trays are stacked.
5. Keep adhesive below the aperture rim and let it cure outside the case.
6. Slide one Boveda pack into each core recess.
7. Place five reeds in the guide-wall passages on each face. Wrap two thin
   elastic bands completely around the tray through the aligned wall notches.

## 5. Gasket

1. Cut 2 mm closed-cell silicone cord slightly long.
2. Dry-fit it in the lid groove with the seam at the rear, away from the latch.
3. Trim for a butt joint; do not leave a gap or overlap.
4. Bond only the joint and intermittent points if needed. Let adhesive cure.
5. Close the empty case for several hours to set the gasket.

## 6. Airtightness test

Do not submerge the case with reeds, Boveda, magnets, or unsealed PLA inside.

1. Put dry tissue inside the empty case.
2. Close and latch it.
3. Brush soapy water around the seam while gently squeezing the broad shell
   faces. Persistent bubbles identify leakage.
4. Alternatively, place a small calibrated hygrometer inside and compare the
   stability curve against an unsealed control over 24 hours.
5. Fix local leaks by correcting gasket compression. If air passes through the
   shell itself, improve extrusion or coat the interior with a fully cured,
   compatible sealant.

This is instrument storage, not a pressure vessel or food-safe container.

## 7. First humidity trial

Use sacrificial/low-value reeds first. Boveda recommends Size 8 at 72% for
less-active storage and Size 8 at 84% for same-day active use. Do not combine
different RH packs or another humidifier in the same case.
