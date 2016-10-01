use Mix.Config

config :db, Nebula.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: System.get_env("POSTGRES_PORT_5432_TCP_ADDR"),
  port: System.get_env("POSTGRES_PORT_5432_TCP_PORT"),
  username: "postgres",
  database: "nebula_prod",
  pool_size: 20 # The amount of database connections in the pool
