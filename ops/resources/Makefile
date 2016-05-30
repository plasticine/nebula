SHELL = /bin/bash -o pipefail

.PHONY: all get destroy

all: plan apply

get:
	terraform get

.DELETE_ON_ERROR:
plan: get
	terraform plan \
		-var-file="../images/base/amis.json" \
		-var-file="../images/nat/amis.json" \
		-var-file="../images/consul/amis.json" \
		-var-file="../images/nomad/amis.json" \
		-out=plan

.DELETE_ON_ERROR:
apply: plan
	terraform apply plan
	rm plan

destroy:
	terraform destroy \
		-var-file="../images/base/amis.json" \
		-var-file="../images/nat/amis.json" \
		-var-file="../images/consul/amis.json" \
		-var-file="../images/nomad/amis.json"
