SHELL = /bin/bash -o pipefail

.PHONY: container images infrastructure destroy

all: images infrastructure

images:
	$(MAKE) -C images

infrastructure: images
	$(MAKE) -C infrastructure

destroy:
		$(MAKE) -C infrastructure destroy
