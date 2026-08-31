OPENSCAD ?= openscad
SOURCE := src/export.scad
BUILD := build
PROFILE ?= prototype
OUT := $(BUILD)/reed-case-prototype

.PHONY: help check preview render export export-case export-humidity-cassette export-humidity-cover export-tray export-tray-full export-tray-face-a export-tray-face-b export-tray-parts export-fit zip clean

help: ## Show available commands
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "%-22s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check: ## Compile the main views and printable parts
	@command -v $(OPENSCAD) >/dev/null || { echo "OpenSCAD is required" >&2; exit 127; }
	@mkdir -p $(BUILD)/check
	@for p in bottom_case humidity_cassette bottom_case_shell roller_catch_mechanism roller_catch_hardware case_open case_closed case_exploded case_base case_lid humidity_cover tray_face_a tray_face_b fit_coupon; do \
		echo "Checking $$p"; \
		$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/check/$$p.csg" \
			-D 'mesh_profile="$(PROFILE)"' -D "part=\"$$p\"" $(SOURCE) >/dev/null || exit $$?; \
	done
	@echo "OpenSCAD checks passed."

preview: ## Compile the default open-case view
	@mkdir -p $(BUILD)
	$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/case-open.csg" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="case_open"' $(SOURCE)

render: ## Render useful inspection views to PNG
	@mkdir -p $(BUILD)/renders
	@runner="$(OPENSCAD)"; \
	if command -v xvfb-run >/dev/null 2>&1; then runner="xvfb-run -a $(OPENSCAD)"; fi; \
	for p in bottom_case bottom_case_shell roller_catch_mechanism roller_catch_hardware case_open case_closed case_closed_front case_exploded bottom_case_with_trays humidity_bay_open humidity_bay_closed lid_seal; do \
		echo "Rendering $$p"; \
		$$runner --autocenter --viewall --projection=ortho --imgsize=1600,1000 \
			-o "$(CURDIR)/$(BUILD)/renders/$$p.png" \
			-D 'mesh_profile="$(PROFILE)"' -D "part=\"$$p\"" $(SOURCE) || exit $$?; \
	done
	@echo "Rendered views in $(BUILD)/renders/"

export: export-case export-humidity-cover export-tray export-fit ## Export the complete printable prototype set
	@printf '\nReady for OrcaSlicer in %s\n' "$(OUT)"
	@printf 'The Alise roller catch is purchased hardware and is NOT printed.\n'

export-case: ## Export base and lid STLs with Alise mounting features
	@mkdir -p $(OUT)
	@for p in case_base case_lid; do \
		echo "Exporting $$p"; \
		$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/$$p.stl" \
			-D 'mesh_profile="$(PROFILE)"' -D "part=\"$$p\"" $(SOURCE); \
	done

export-tray: export-tray-parts ## Export the two support-free tray shell halves

export-tray-full: ## Export the complete assembled tray as one STL
	@mkdir -p $(OUT)/tray
	$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/tray/tray_complete.stl" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="tray"' $(SOURCE)

export-tray-face-a: ## Export only tray face A
	@mkdir -p $(OUT)/tray
	$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/tray/tray_face_a.stl" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="tray_face_a"' $(SOURCE)

export-tray-face-b: ## Export only tray face B
	@mkdir -p $(OUT)/tray
	$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/tray/tray_face_b.stl" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="tray_face_b"' $(SOURCE)

export-tray-parts: ## Export tray face A + face B
	@mkdir -p $(OUT)/tray-parts
	$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/tray-parts/tray_face_a.stl" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="tray_face_a"' $(SOURCE)
	@if [ "$(PROFILE)" = "prototype" ]; then \
		cp "$(CURDIR)/$(OUT)/tray-parts/tray_face_a.stl" "$(CURDIR)/$(OUT)/tray-parts/tray_face_b.stl"; \
	else \
		$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/tray-parts/tray_face_b.stl" \
			-D 'mesh_profile="$(PROFILE)"' -D 'part="tray_face_b"' $(SOURCE); \
	fi

export-fit: ## Export the small hinge-pin/magnet fit coupon
	@mkdir -p $(OUT)
	$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/fit_coupon.stl" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="fit_coupon"' $(SOURCE)

export-humidity-cassette: export-humidity-cover ## Backward-compatible alias

export-humidity-cover: ## Export the removable vented humidity-bay cover
	@mkdir -p $(OUT)/humidity-cover
	$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/humidity-cover/humidity_cover.stl" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="humidity_cover"' $(SOURCE)

zip: ## Create/replace reed-case-source.zip for sharing updates
	./scripts/make-source-zip.sh

clean: ## Delete generated build output
	rm -rf -- "$(CURDIR)/$(BUILD)"
