OPENSCAD ?= openscad
SOURCE := src/export.scad
BUILD := build

.PHONY: help check check-tray preview preview-hecate946 preview-fit preview-fit-exploded preview-seal preview-all stl stl-tray stl-tray-parts stl-case stl-hecate946 stl-hecate946-all stl-all stl-size60 stl-size60-all clean

help:
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "%-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check: ## Run static project checks
	python3 scripts/check_scad.py

check-tray: check ## Fast compile/preflight of one-piece tray source regions
	@mkdir -p "$(CURDIR)/build/preflight"
	$(OPENSCAD) -o "$(CURDIR)/build/preflight/behn_tray_face_a.csg" -D 'preset="hecate946"' -D 'print_profile="library_fdm"' -D 'part="behn_tray_face_a"' $(SOURCE)
	$(OPENSCAD) -o "$(CURDIR)/build/preflight/behn_tray_face_b.csg" -D 'preset="hecate946"' -D 'print_profile="library_fdm"' -D 'part="behn_tray_face_b"' $(SOURCE)
	$(OPENSCAD) -o "$(CURDIR)/build/preflight/behn_tray_core_monolithic.csg" -D 'preset="hecate946"' -D 'print_profile="library_fdm"' -D 'part="behn_tray_core_monolithic"' $(SOURCE)

preview: preview-hecate946 ## Compile the HECATE946 closed assembly

preview-hecate946: check ## Compile HECATE946 closed assembly to CSG
	@mkdir -p $(BUILD)
	$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/hecate946_assembly.csg" -D 'preset="hecate946"' -D 'part="hecate946_assembly"' $(SOURCE)

preview-fit: check ## Compile base with both actual trays seated
	@mkdir -p $(BUILD)
	$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/hecate946_nested.csg" -D 'preset="hecate946"' -D 'part="hecate946_nested"' $(SOURCE)

preview-fit-exploded: check ## Compile lifted-tray fit inspection view
	@mkdir -p $(BUILD)
	$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/hecate946_nested_exploded.csg" -D 'preset="hecate946"' -D 'part="hecate946_nested_exploded"' $(SOURCE)

preview-seal: check ## Compile lid with the 2x185 silicone O-ring path highlighted
	@mkdir -p $(BUILD)
	$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/hecate946_seal_view.csg" -D 'preset="hecate946"' -D 'part="hecate946_seal_view"' $(SOURCE)

preview-all: check ## Compile the original Premium-20 assembly to CSG
	@mkdir -p $(BUILD)
	$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/assembly.csg" -D 'preset="behn_premium20"' -D 'part="assembly"' $(SOURCE)

stl: check ## Export one production-mesh five-lane double-sided tray (A, B, core)
	./scripts/build.sh hecate946 prototype

stl-tray: check-tray ## Export ONE permanently fused, library-ready Behn tray STL
	./scripts/export-library-tray.sh

stl-tray-parts: check ## Legacy: export the old three-piece tray set
	./scripts/export-library-tray-parts.sh

stl-case: stl-hecate946 ## Alias: export the HECATE946 base/lid/hinge coupon

stl-hecate946: check ## Export HECATE946 base, lid, and metal-pin fit coupon
	./scripts/build.sh hecate946 case

stl-hecate946-all: check ## Export HECATE946 case plus one tray set and coupons
	./scripts/build.sh hecate946 all

stl-all: check ## Export every original Premium-20 printable part
	./scripts/build.sh behn_premium20 all

stl-size60: check ## Export exactly one Size-60 prototype tray
	./scripts/build.sh size60_studio prototype

stl-size60-all: check ## Export every Size-60 printable part
	./scripts/build.sh size60_studio all

clean: ## Remove generated files
	@target="$(CURDIR)/$(BUILD)"; case "$$target" in "$(CURDIR)/build") rm -rf -- "$$target" ;; *) echo "Refusing unsafe clean target"; exit 1 ;; esac
