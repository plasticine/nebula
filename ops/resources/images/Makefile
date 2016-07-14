SHELL = /bin/bash -o pipefail
NUMPROCS:=$(shell sysctl -n hw.ncpu)
BUILD_DIR = _build
IMAGES = base

.PHONY: all

define logfile_path
$(BUILD_DIR)/$(1).packer.build.log
endef

define get_image_id
grep "A disk image was created:" $(call logfile_path,$(1)) | cut -d ' ' -f8
endef

define IMAGE_template
$(BUILD_DIR)/$(1).json:
	@echo "Running IMAGE_template for $(1)"
	$(eval @$_logfile = $(call logfile_path,$(1)))
	@rm $(@$_logfile) || true
	packer build -var-file=variables.json $(2) $(1)/main.json | tee $(@$_logfile)
	@echo "{\"$(1)_image_name\":\"$(eval $(call get_image_id,$(1)))\"}" > $$@
	rm $$@
endef

$(foreach image,$(IMAGES), $(eval $(call IMAGE_template,$(image))))
all: $(foreach image,$(IMAGES), $(BUILD_DIR)/$(image).json)
