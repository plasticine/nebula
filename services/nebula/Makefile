.PHONY: test bootstrap

test:
  rm -rf coverage
  docker-compose run --rm -e MIX_ENV=test orchestrator test

bootstrap:
  docker compose build
  docker compose run --rm orchestrator deps.get ecto.setup test.prepare
