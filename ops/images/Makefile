SHELL = /bin/bash -o pipefail

BASE_FILES   = $(shell find base ! -name 'amis.json' ! -name '.DS_Store')
NAT_FILES    = $(shell find nat ! -name 'amis.json' ! -name '.DS_Store')
CONSUL_FILES = $(shell find consul ! -name 'amis.json' ! -name '.DS_Store')
NOMAD_FILES  = $(shell find nomad ! -name 'amis.json' ! -name '.DS_Store')
NODE_FILES   = $(shell find node ! -name 'amis.json' ! -name '.DS_Store')

NUMPROCS:=$(shell sysctl -n hw.ncpu)

.PHONY: all clean

all:
	make -j$(NUMPROCS) \
		base/amis.json \
		nat/amis.json \
		consul/amis.json \
		nomad/amis.json \
		node/amis.json

clean:
	-rm -rf log/*.log

.DELETE_ON_ERROR:
base/amis.json: $(BASE_FILES)
	packer build base/main.json | tee log/build.base.log
	# TODO should also clean up the old AMI and snapshot here...
	# aws ec2 deregister-image --image-id ami-4fa54026

.DELETE_ON_ERROR:
nat/amis.json: $(NAT_FILES) base/amis.json
	packer build --var-file=base/amis.json nat/main.json | tee log/build.nat.log

.DELETE_ON_ERROR:
consul/amis.json: $(CONSUL_FILES) base/amis.json
	packer build --var-file=base/amis.json consul/main.json | tee log/build.consul.log

.DELETE_ON_ERROR:
nomad/amis.json: $(NOMAD_FILES) base/amis.json
	packer build --var-file=base/amis.json nomad/main.json | tee log/build.nomad.log

.DELETE_ON_ERROR:
node/amis.json: $(NOMAD_FILES) base/amis.json
	packer build --var-file=base/amis.json node/main.json | tee log/build.node.log
