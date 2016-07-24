SHELL = /bin/bash -o pipefail

.PHONY: all images get destroy

all: images plan apply

images:
	$(MAKE) -C images

get:
	terraform get

.DELETE_ON_ERROR:
plan: get
	terraform plan \
		-out=plan \
		-var-file="images/_build/base_image.json" \
		-var-file="images/_build/bastion_image.json" \
		-var-file="images/_build/node_image.json"

.DELETE_ON_ERROR:
apply: plan
	terraform apply plan
	rm plan

destroy:
	terraform destroy \
		-var-file="images/_build/base_image.json" \
		-var-file="images/_build/bastion_image.json" \
		-var-file="images/_build/node_image.json"
