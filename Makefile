OPENSCAD ?= openscad
SOURCE := src/export.scad
BUILD := build
PROFILE ?= prototype
OUT := $(BUILD)/reed-case-prototype

.PHONY: help check preview render export export-case export-latch export-mounts export-tray export-tray-parts export-fit zip clean

help: ## Show available commands
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "%-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check: ## Compile the main views and printable parts without making STLs
	@command -v $(OPENSCAD) >/dev/null || { echo "OpenSCAD is required" >&2; exit 127; }
	@mkdir -p $(BUILD)/check
	@for p in bottom_case bottom_case_boveda_size_60 bottom_case_shell bottom_case_latch_fit bottom_case_latch_pressed latch_piece latch_groove_lock_detail latch_groove_closing_entry latch_button_release_detail top_lid_latch_groove leaf_spring_mount_pair left_leaf_spring_mount right_leaf_spring_mount case_open case_closed case_exploded case_base case_lid tray_face_a tray_core tray_face_b fit_coupon; do \
		echo "Checking $$p"; \
		$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/check/$$p.csg" \
			-D 'mesh_profile="$(PROFILE)"' -D "part=\"$$p\"" $(SOURCE) >/dev/null || exit $$?; \
	done
	@for p in _latch_fit_interference _latch_pressed_base_interference _latch_complete_lid_locked_interference _latch_complete_lid_entry_interference _latch_complete_lid_released_interference _latch_draw_path_interference _latch_groove_pressed_engagement; do \
		out="$(CURDIR)/$(BUILD)/check/$$p.stl"; \
		log="$(CURDIR)/$(BUILD)/check/$$p.log"; \
		rm -f -- "$$out"; \
		$(OPENSCAD) -o "$$out" -D 'mesh_profile="$(PROFILE)"' \
			-D "part=\"$$p\"" $(SOURCE) >"$$log" 2>&1 || true; \
		if rg -q '^ERROR:' "$$log"; then cat "$$log" >&2; exit 1; fi; \
		if test -s "$$out"; then \
			echo "Latch clearance check failed: $$p is non-empty" >&2; \
			exit 1; \
		fi; \
	done
	@out="$(CURDIR)/$(BUILD)/check/_latch_groove_locked_engagement.stl"; \
	log="$(CURDIR)/$(BUILD)/check/_latch_groove_locked_engagement.log"; \
	rm -f -- "$$out"; \
	$(OPENSCAD) -o "$$out" -D 'mesh_profile="$(PROFILE)"' \
		-D 'part="_latch_groove_locked_engagement"' $(SOURCE) >"$$log" 2>&1 || true; \
	if rg -q '^ERROR:' "$$log"; then cat "$$log" >&2; exit 1; fi; \
	if ! test -s "$$out"; then \
		echo "Latch engagement check failed: locked hook does not enter lid groove" >&2; \
		exit 1; \
	fi
	@echo "OpenSCAD checks passed."

preview: ## Compile the default open-case view
	@mkdir -p $(BUILD)
	$(OPENSCAD) -o "$(CURDIR)/$(BUILD)/case-open.csg" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="case_open"' $(SOURCE)

render: ## Render the useful inspection views to PNG
	@mkdir -p $(BUILD)/renders
	@runner="$(OPENSCAD)"; \
	if command -v xvfb-run >/dev/null 2>&1; then \
		runner="xvfb-run -a $(OPENSCAD)"; \
	fi; \
	for p in bottom_case bottom_case_boveda_size_60 bottom_case_shell bottom_case_latch_fit bottom_case_latch_pressed latch_piece latch_groove_lock_detail latch_groove_closing_entry latch_button_release_detail top_lid_latch_groove leaf_spring_mount_pair case_open case_closed case_closed_front case_exploded bottom_case_with_trays lid_seal; do \
		echo "Rendering $$p"; \
		$$runner --autocenter --viewall --projection=ortho --imgsize=1600,1000 \
			-o "$(CURDIR)/$(BUILD)/renders/$$p.png" \
			-D 'mesh_profile="$(PROFILE)"' -D "part=\"$$p\"" $(SOURCE) || exit $$?; \
	done
	@echo "Rendered views in $(BUILD)/renders/"

export: export-case export-latch export-mounts export-tray export-fit ## Export the prototype; print the tray STL twice
	@printf '\nReady for OrcaSlicer in %s\n' "$(OUT)"
	@printf 'Print: case_base/lid x1; tray_face_a/core/face_b x2 each\n'

export-case: ## Export base and lid STLs
	@mkdir -p $(OUT)
	@for p in case_base case_lid; do \
		echo "Exporting $$p"; \
		$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/$$p.stl" \
			-D 'mesh_profile="$(PROFILE)"' -D "part=\"$$p\"" $(SOURCE); \
	done

export-latch: ## Export the separate moving front latch
	@mkdir -p $(OUT)/latch
	$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/latch/latch_piece.stl" \
		-D 'mesh_profile="$(PROFILE)"' -D 'part="latch_piece"' $(SOURCE)

export-mounts: ## Export both mirrored mount components separately for tweaking
	@mkdir -p $(OUT)/spring-mounts
	@for p in left_leaf_spring_mount right_leaf_spring_mount; do \
		echo "Exporting $$p"; \
		$(OPENSCAD) --export-format binstl -o "$(CURDIR)/$(OUT)/spring-mounts/$$p.stl" \
			-D 'mesh_profile="$(PROFILE)"' -D "part=\"$$p\"" $(SOURCE) || exit $$?; \
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
