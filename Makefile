SHELL = /bin/bash -o pipefail
TEMPDIR := $(shell mktemp -d)
NUMPROCS := $(shell sysctl -n hw.ncpu)

.PHONY: bootstrap prepare

prepare:
	docker-compose down --remove-orphans
	docker-compose rm -fva
	docker-compose build
	docker-compose run --rm nebula deps.get
	docker-compose run --rm nebula ecto.setup
	docker-compose run --rm nebula test.prepare

bootstrap: prepare

up:
	docker-compose up --remove-orphans
