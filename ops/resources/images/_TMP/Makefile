SHELL = /bin/bash -o pipefail
NUMPROCS:=$(shell sysctl -n hw.ncpu)

BASE_FILES = $(shell find base ! -name 'image.json' ! -name '.DS_Store')
NAT_FILES = $(shell find nat ! -name 'image.json' ! -name '.DS_Store')

.PHONY: all clean

define build-image
rm log/packer.image.$(1).log || true
packer build -var-file=variables.json $(2) $(1)/main.json | tee log/packer.image.$(1).log
endef

define save-image-id
$(eval $@_image_name := $$(shell grep "A disk image was created:" log/packer.image.$(1).log | cut -d ' ' -f8))
echo "{\"$(1)_image_name\":\"$($@_image_name)\"}" > $@
endef

all:
	make -j$(NUMPROCS) \
		base/image.json \
		nat/image.json

.DELETE_ON_ERROR:
base/image.json: $(BASE_FILES)
	$(call build-image,base)
	$(call save-image-id,base)

.DELETE_ON_ERROR:
nat/image.json: base/image.json $(NAT_FILES)
	$(call build-image,nat,-var-file=base/image.json)
	$(call save-image-id,nat)
