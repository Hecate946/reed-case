OPENSCAD ?= openscad
SOURCE := src/export.scad
BUILD := build

.PHONY: help check preview preview-all stl stl-all stl-size60 stl-size60-all clean

help:
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "%-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check: ## Run static project checks
	python3 scripts/check_scad.py

preview: check ## Compile the default single-tray prototype to CSG
	@mkdir -p $(BUILD)
	$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/behn_tray.csg" -D 'preset="behn_premium20"' -D 'part="behn_tray"' $(SOURCE)

preview-all: check ## Compile the full case assembly to CSG
	@mkdir -p $(BUILD)
	$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/assembly.csg" -D 'preset="behn_premium20"' -D 'part="assembly"' $(SOURCE)

stl: check ## Export exactly one Behn prototype tray (face A, face B, core)
	./scripts/build.sh behn_premium20 prototype

stl-all: check ## Export every Behn-envelope printable part
	./scripts/build.sh behn_premium20 all

stl-size60: check ## Export exactly one Size-60 prototype tray
	./scripts/build.sh size60_studio prototype

stl-size60-all: check ## Export every Size-60 printable part
	./scripts/build.sh size60_studio all

clean: ## Remove generated files
	@target="$(CURDIR)/$(BUILD)"; case "$$target" in "$(CURDIR)/build") rm -rf -- "$$target" ;; *) echo "Refusing unsafe clean target"; exit 1 ;; esac
