use Mix.Config

config :repo, Nebula.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "postgres",
  username: "postgres",
  port: 5432,
  database: "nebula_dev",
  pool_size: 10 # The amount of database connections in the pool
