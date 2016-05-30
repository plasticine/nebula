SHELL = /bin/bash -o pipefail

.PHONY: vm bootstrap

bootstrap:
	vagrant up --provision
	docker-compose down --remove-orphans
	docker-compose rm -fva
	docker-compose build
	docker-compose run --rm orchestrator deps.get
	docker-compose run --rm orchestrator ecto.setup
	docker-compose run --rm orchestrator test.prepare
