use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :orchestrator, Orchestrator.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :orchestrator, Orchestrator.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "localhost",
  username: "postgres",
  port: 5432,
  database: "orchestrator_test",
  pool: Ecto.Adapters.SQL.Sandbox
