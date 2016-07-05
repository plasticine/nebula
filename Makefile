SHELL = /bin/bash -o pipefail
TEMPDIR := $(shell mktemp -d)
NUMPROCS := $(shell sysctl -n hw.ncpu)
CONSUL_VERSION = 0.6.4
NOMAD_VERSION = 0.4.0

.PHONY: bootstrap dev vm prepare

dev: vm .dev/bin/consul .dev/consul/ui .dev/bin/nomad
	HOSTNAME=$(shell hostname) docker-compose up

.dev:
	mkdir -p .dev/{bin,consul,nomad}

.dev/bin/consul: .dev
	curl -sSL "https://releases.hashicorp.com/consul/$(CONSUL_VERSION)/consul_$(CONSUL_VERSION)_darwin_amd64.zip" -o "$(TEMPDIR)/consul.zip"
	unzip -o "$(TEMPDIR)/consul.zip" -d .dev/bin/
	chmod +x .dev/bin/consul

.dev/bin/nomad: .dev
	curl -sSL "https://releases.hashicorp.com/nomad/$(NOMAD_VERSION)/nomad_$(NOMAD_VERSION)_darwin_amd64.zip" -o "$(TEMPDIR)/nomad.zip"
	unzip -o "$(TEMPDIR)/nomad.zip" -d .dev/bin/
	chmod +x .dev/bin/nomad

.dev/consul/ui: .dev
	mkdir -p .dev/consul
	curl -sSL "https://releases.hashicorp.com/consul/$(CONSUL_VERSION)/consul_$(CONSUL_VERSION)_web_ui.zip" -o "$(TEMPDIR)/consul_ui.zip"
	unzip -o "$(TEMPDIR)/consul_ui.zip" -d .dev/consul/ui

vm:
	vagrant up --provision

prepare:
	docker-compose down --remove-orphans
	docker-compose rm -fva
	docker-compose build
	docker-compose run --rm nebula deps.get
	docker-compose run --rm nebula ecto.setup
	docker-compose run --rm nebula test.prepare

bootstrap: dev prepare

up:
	docker-compose up --remove-orphans
