use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :nebula, Nebula.Endpoint,
  secret_key_base: "jX1SsYGb0uYaAFs74bSdiDcAVbFm58O5Tg16nMUEMVzEkgzcOxENcoWrSMhYUdl8"

config :exsentry,
  dsn: System.get_env("API_SENTRY_DSN")

# Configure your database
config :nebula, Nebula.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: System.get_env("POSTGRES_PORT_5432_TCP_ADDR"),
  port: System.get_env("POSTGRES_PORT_5432_TCP_PORT"),
  username: "postgres",
  database: "nebula_prod",
  pool_size: 20 # The amount of database connections in the pool
