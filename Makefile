OPENSCAD ?= openscad
SOURCE := src/export.scad
BUILD := build
PARTS := base lid behn_tray_face behn_tray_core hinge_pin latch_clip gasket_coupon tolerance_coupon assembly

.PHONY: help check preview stl stl-size60 clean

help:
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "%-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check: ## Run static project checks
	python3 scripts/check_scad.py

preview: check ## Ask OpenSCAD to compile the default assembly to CSG
	@mkdir -p $(BUILD)
	$(OPENSCAD) -o $(BUILD)/assembly.csg -D 'preset="behn_premium20"' -D 'part="assembly"' $(SOURCE)

stl: check ## Export all Behn-envelope printable parts
	./scripts/build.sh behn_premium20

stl-size60: check ## Export all Size-60 printable parts
	./scripts/build.sh size60_studio

clean: ## Remove generated files
	@target="$(CURDIR)/$(BUILD)"; case "$$target" in "$(CURDIR)/build") rm -rf -- "$$target" ;; *) echo "Refusing unsafe clean target"; exit 1 ;; esac
