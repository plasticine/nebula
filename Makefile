SHELL = /bin/bash -o pipefail
TEMPDIR := $(shell mktemp -d)
NUMPROCS := $(shell sysctl -n hw.ncpu)
HOST_IP := "$(shell (ifconfig en0 | grep 'inet ' || ifconfig en1 | grep 'inet ') | cut -d " " -f2)"

.PHONY: bootstrap vm prepare

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

inspect:
	docker-compose exec nebula iex --name debug@127.0.0.1 --hidden -e ":observer.start"

console:
	docker-compose exec nebula iex --name debug@127.0.0.1 --hidden --remsh "nebula@127.0.0.1"
