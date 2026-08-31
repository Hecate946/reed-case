# Center front-latch hardware

The case uses one centered front push button with the same latch kinematics as
the previous side mechanism: the lid cams the rounded catch inward, the leaf
spring returns the latch outward into the lid groove, and pressing the button
retracts the catch. At full press the button face is flush with the front wall.

## Leaf spring

Prototype material: **301 full-hard stainless spring/shim stock, 0.006 in
(0.1524 mm)**.

Use `front_leaf_spring_strip.dxf` as the cutting/drilling template:

- about 35 mm long x 7 mm high
- two 2.3 mm clearance holes on a 31 mm screw span
- one spring is required

Install it with a shallow outward pre-bow. The exact force should be tuned on a
physical prototype; 0.006 in is the intended starting thickness.

## Interior cover

Use `front_latch_cover_plate.dxf`. Make **one** from:

- 0.030 in / 0.76 mm 304 stainless steel
- deburred edges recommended

The plate screws into the two printed support blocks and hides the spring and
moving latch from the cartridge area. The same two screws clamp the spring ends.

Prototype fasteners:

- 2x M2 x 5 mm thread-forming screws
- 1.6 mm printed pilot holes
- 2.3 mm cover/spring clearance holes

## Export

```bash
make export-front-latch-hardware
```

Outputs are written under:

`build/reed-case-prototype/front-latch-hardware/`
