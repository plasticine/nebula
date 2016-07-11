SHELL = /bin/bash -o pipefail
NUMPROCS:=$(shell sysctl -n hw.ncpu)

BASE_FILES = $(shell find base ! -name 'image.json' ! -name '.DS_Store')

.PHONY: all clean

define build-image
rm log/packer.build.$(1).log || true
packer build -var-file=variables.json $(2) $(1)/main.json | tee log/packer.image.$(1).log
@sleep 1
$(eval $@_image_name := $(shell grep "A disk image was created:" log/packer.image.$(1).log | cut -d ' ' -f8))
@echo "$($@_image_name)"
@echo "{\"$(1)_image_name\":\"$($@_image_name)\"}" > $@
cat $@
# TODO should also clean up the old image here...
endef

all:
	make -j$(NUMPROCS) \
		base/image.json

.DELETE_ON_ERROR:
base/image.json: $(BASE_FILES)
	$(call build-image,base)
