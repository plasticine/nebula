use Mix.Config

config :repo, Nebula.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "localhost",
  username: "postgres",
  port: 5432,
  database: "nebula_test",
  pool: Ecto.Adapters.SQL.Sandbox
