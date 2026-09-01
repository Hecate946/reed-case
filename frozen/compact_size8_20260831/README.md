# Reed case CAD

OpenSCAD source for the current H946 reed-case prototype.



## Closure hardware

The custom pushbutton / leaf-spring / hook / striker system has been removed.
The case now mounts one purchased **Alise CA100S-4P (CA100-4P) 40 mm double-roller catch** centered in the front service strip. The roller body sits on an integrated base pedestal just below the case seam; the matching striker screws to a recessed ledge on the lid. There is no external button. Pulling the lid apart releases the rollers.

Useful OpenSCAD views:

```scad
view = "roller_catch_mechanism";
view = "roller_catch_hardware";
view = "case_open";
view = "case_closed";
```

The purchased catch is not exported as a printable part. `make export-case` exports the base and lid with the mounting bosses, locating seats, and screw pilots already integrated.


### Flush Alise catch integration
The centered front catch housing now uses the seller drawing directly: the 40 x 9 mm, 10 mm-high main catch sits in a top-loading recess molded into a locally 12.8 mm-thick front wall. The exterior remains seamless. The 22 x 8 mm striker plate is recessed flush into the lid rim, with only its 5 mm tongue projecting into the rollers. The ordinary shell remains 4.2 mm thick away from the catch.
