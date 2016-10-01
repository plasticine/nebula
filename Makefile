SHELL = /bin/bash -o pipefail
TEMPDIR := "$(shell mktemp -d)"
NUMPROCS := "$(shell sysctl -n hw.ncpu)"
HOST_IP := "$(shell (ifconfig en0 | grep 'inet ' || ifconfig en1 | grep 'inet ') | cut -d " " -f2)"

.PHONY: bootstrap vm.up docker.build

bootstrap: vm.up docker.build db.prepare

up:
	@killall epmd > /dev/null || true
	HOST_IP=$(HOST_IP) docker-compose up --force-recreate --remove-orphans

vm.provision: .vagrant
	vagrant provision

vm.up:
	vagrant up

docker.build:
	docker-compose down --remove-orphans
	docker-compose rm -fva
	docker-compose build

nebula.deps.get:
	docker-compose run --rm nebula mix deps.get

nebula.db.setup:
	docker-compose run --rm nebula mix do ecto.create, ecto.migrate

nebula.inspect:
	docker-compose exec nebula iex --name debug@127.0.0.1 --hidden -e ":observer.start"

nebula.console:
	docker-compose exec nebula iex --name debug@127.0.0.1 --hidden --remsh "nebula@127.0.0.1"
