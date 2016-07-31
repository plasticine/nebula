SHELL = /bin/bash -o pipefail
TEMPDIR := $(shell mktemp -d)
NUMPROCS := $(shell sysctl -n hw.ncpu)
HOST_IP := "$(shell (ifconfig en0 | grep 'inet ' || ifconfig en1 | grep 'inet ') | cut -d " " -f2)"
CONSUL_VERSION = 0.6.4
NOMAD_VERSION = 0.4.0

.PHONY: bootstrap dev vm prepare

dev: vm .dev/bin/consul .dev/consul/ui .dev/bin/nomad

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
	docker-compose run --rm nebula mix do deps.get, ecto.setup

bootstrap: dev prepare

up:
	@killall epmd > /dev/null || true
	HOST_IP=$(HOST_IP) docker-compose up --force-recreate --remove-orphans

nebula_inspect:
	docker-compose exec nebula iex --name debug@127.0.0.1 --hidden -e ":observer.start"
