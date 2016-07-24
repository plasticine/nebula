SHELL = /bin/bash -o pipefail
NUMPROCS:=$(shell sysctl -n hw.ncpu)
BUILD_DIR = _build
IMAGES = base bastion node

define logfile_path
$(BUILD_DIR)/log/$(1).packer.build.log
endef

define BUILD_IMAGE_TEMPLATE
$(BUILD_DIR)/$(1)_image.json: $(shell find $(1) -type f ! -name '.DS_Store')
	$(eval @$_logfile = $(call logfile_path,$(1)))
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/log
	@rm $(@$_logfile) || true
	packer build \
	  -var-file=variables.json \
		$$(shell find $(BUILD_DIR) -type f -name "*_image.json" | sed 's/^/-var-file=/' | xargs) \
		$(1)/main.json | tee $(@$_logfile)
	@grep "A disk image was created:" $(call logfile_path,$(1)) | cut -d ' ' -f8 | sed 's/^/{\"$(1)_image_name\":\"/' | sed 's/$$$$/\"}/' > $$@
	@cat $$@
endef

$(foreach image,$(IMAGES), $(eval $(call BUILD_IMAGE_TEMPLATE,$(image))))

all: $(IMAGES)
base: $(BUILD_DIR)/base_image.json
bastion: base $(BUILD_DIR)/bastion_image.json
node: base $(BUILD_DIR)/node_image.json

.PHONY: all $(IMAGES)
.DEFAULT_GOAL := all
