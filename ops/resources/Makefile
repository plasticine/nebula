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
		-var-file="images/base/image.json" \
		-out=plan

.DELETE_ON_ERROR:
apply: plan
	terraform apply plan
	rm plan

destroy:
	terraform destroy \
		-var-file="images/base/image.json" \
