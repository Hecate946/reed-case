OPENSCAD ?= openscad
SOURCE := src/export.scad
BUILD := build
PROFILE ?= prototype
OUT := $(BUILD)/v2-prototype

.PHONY: help check preview render export export-case export-tray export-tray-parts export-fit zip clean

help: ## Show available commands
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "%-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check: ## Compile the main views and printable parts without making STLs
	@command -v $(OPENSCAD) >/dev/null || { echo "OpenSCAD is required" >&2; exit 127; }
	@mkdir -p $(BUILD)/check
	@for p in v2_open v2_closed v2_exploded case_base case_lid tray_face_a tray_core tray_face_b fit_coupon; do \
		echo "Checking $$p"; \
		$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/check/$$p.csg" \
			-D 'mesh_profile="$(PROFILE)"' -D "part=\"$$p\"" $(SOURCE) >/dev/null; \
	done
	@echo "OpenSCAD checks passed."

preview: ## Compile the default open-case view to build/v2-open.csg
	@mkdir -p $(BUILD)
	$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/v2-open.csg" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="v2_open"' $(SOURCE)

render: ## Render the useful V2 inspection views to PNG
	@mkdir -p $(BUILD)/renders
	@runner="$(OPENSCAD)"; \
	if command -v xvfb-run >/dev/null 2>&1; then \
		runner="xvfb-run -a $(OPENSCAD)"; \
	fi; \
	for p in v2_open v2_closed v2_closed_front v2_exploded v2_base_fit v2_seal; do \
		echo "Rendering $$p"; \
		$$runner --autocenter --viewall --projection=ortho --imgsize=1600,1000 \
			-o "$(CURDIR)/$(BUILD)/renders/$$p.png" \
			-D 'mesh_profile="$(PROFILE)"' -D "part=\"$$p\"" $(SOURCE) || exit $$?; \
	done
	@echo "Rendered views in $(BUILD)/renders/"

export: export-case export-tray export-fit ## Export the full V2 prototype; print the tray STL twice
	@printf '\nReady for OrcaSlicer in %s\n' "$(OUT)"
	@printf 'Print: case_base/lid x1; tray_face_a/core/face_b x2 each\n'

export-case: ## Export V2 base and lid STLs
	@mkdir -p $(OUT)
	@for p in case_base case_lid; do \
		echo "Exporting $$p"; \
		$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/$$p.stl" \
			-D 'mesh_profile="$(PROFILE)"' -D "part=\"$$p\"" $(SOURCE); \
	done

export-tray: export-tray-parts ## Export one support-free tray set as three STLs

export-tray-parts: ## Export tray face A + core + face B
	@mkdir -p $(OUT)/tray-parts
	@echo "Exporting tray_face_a"
	$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/tray-parts/tray_face_a.stl" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="tray_face_a"' $(SOURCE)
	@echo "Exporting tray_core"
	$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/tray-parts/tray_core.stl" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="tray_core"' $(SOURCE)
	@if [ "$(PROFILE)" = "prototype" ]; then \
		cp "$(CURDIR)/$(OUT)/tray-parts/tray_face_a.stl" \
		   "$(CURDIR)/$(OUT)/tray-parts/tray_face_b.stl"; \
		echo "Copied tray_face_b (same prototype geometry; numbering is fine-profile only)"; \
	else \
		echo "Exporting tray_face_b"; \
		$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/tray-parts/tray_face_b.stl" \
			-D 'mesh_profile="$(PROFILE)"' -D 'part="tray_face_b"' $(SOURCE); \
	fi

export-fit: ## Export the small hinge-pin/magnet fit coupon
	@mkdir -p $(OUT)
	$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/fit_coupon.stl" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="fit_coupon"' $(SOURCE)

zip: ## Create/replace reed-case-source.zip for sharing updates
	./scripts/make-source-zip.sh

clean: ## Delete generated build output
	rm -rf -- "$(CURDIR)/$(BUILD)"
