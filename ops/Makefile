SHELL = /bin/bash -o pipefail

.PHONY: container images resources destroy

all: images resources

images:
	$(MAKE) -C images

resources: images
	$(MAKE) -C resources

destroy:
	$(MAKE) -C resources destroy
