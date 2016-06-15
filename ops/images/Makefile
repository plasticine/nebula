SHELL = /bin/bash -o pipefail

BASE_FILES   = $(shell find base ! -name 'amis.json' ! -name '.DS_Store')
CONSUL_FILES = $(shell find consul ! -name 'amis.json' ! -name '.DS_Store')
# NAT_FILES    = $(shell find nat ! -name 'amis.json' ! -name '.DS_Store')
# NOMAD_FILES  = $(shell find nomad ! -name 'amis.json' ! -name '.DS_Store')
# NODE_FILES   = $(shell find node ! -name 'amis.json' ! -name '.DS_Store')

NUMPROCS:=$(shell sysctl -n hw.ncpu)

.PHONY: all clean

define build-image
packer build -var-file=variables.json $(2) $(1)/main.json | tee log/build.$(1).log
echo "{\"$(1)_image_name\":\"$(shell grep "A disk image was created:" log/build.$(1).log | cut -d ' ' -f8)\"}" > $@
# TODO should also clean up the old image here...
endef

all:
	make -j$(NUMPROCS) \
		base/build.json \
		consul/build.json
		# nat/amis.json \
		# nomad/amis.json \
		# node/amis.json

clean:
	-rm -rf log/*.log

.DELETE_ON_ERROR:
base/build.json: $(BASE_FILES)
	$(call build-image,base)

.DELETE_ON_ERROR:
consul/build.json: $(CONSUL_FILES) base/build.json
	$(call build-image,consul,--var-file=base/build.json)

# .DELETE_ON_ERROR:
# nomad/amis.json: $(NOMAD_FILES) base/amis.json
# 	packer build --var-file=base/amis.json nomad/main.json | tee log/build.nomad.log

# .DELETE_ON_ERROR:
# node/amis.json: $(NOMAD_FILES) base/amis.json
# 	packer build --var-file=base/amis.json node/main.json | tee log/build.node.log
