SHELL = /bin/bash -o pipefail

.PHONY: bootstrap vm_provision prepare

vm_provision:
	vagrant up --provision

prepare:
	docker-compose down --remove-orphans
	docker-compose rm -fva
	docker-compose build
	docker-compose run --rm nebula deps.get
	docker-compose run --rm nebula ecto.setup
	docker-compose run --rm nebula test.prepare

bootstrap: vm_provision prepare

